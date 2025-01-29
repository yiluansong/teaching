---
title: "CI/CD"
author: "Yiluan Song"
date: "2025-01-28"
output: html_document
---

## Introduction

In this tutorial, we'll walk through the steps of setting up a continuous integration  (CI) pipeline using [GitHub Actions](https://docs.github.com/en/actions). We will also demonstrate how to achieve continuous deployment (CD) to two cloud-based platforms, a more specialized shinyapps.io and a more general [AWS ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html) and [AWS App Runner](https://docs.aws.amazon.com/apprunner/latest/dg/what-is-apprunner.html).

We will specifically be focusing on deploying a Shiny app, but the concepts can easily be adapted for any application. [Here](https://github.com/zhulabgroup/phenology-website) is my repository as an example.

## Prepare for deployment on Shinyapps.io

### Get credentials

To host a Shiny app on shinyapps.io, you need to have a [shinyapps.io](https://www.shinyapps.io/) account. You can sign up for a free account if you don't have one. Follow the steps below to get your shinyapps.io credentials.

1. Go to your [shinyapps.io](https://www.shinyapps.io/) account and log in.
2. Navigate to **Account** and **Tokens**.
3. Click on **Add Token** to generate a new token. Skip if you already have one.
4. Click on **Show** to reveal the credentials.

### Setting up GitHub secrets

For secure communication between GitHub and the shinyapps.io, we need to store sensitive credentials in GitHub Secrets. You will need the following secrets: `SHINYAPPS_USER`, `SHINYAPPS_TOKEN`, and `SHINYAPPS_SECRET`.

To add secrets to your repository:
1. Go to the repository's **Settings**.
2. Navigate to **Secrets**.
3. Click on **New repository secret** and add the relevant keys.

## Prepare for deployment on AWS App Runner

To host a Shiny app on AWS App Runner, you need to have an AWS account with access to ECR and App Runner services. Set up an AWS account if necessary.

### Prepare a Docker file

We need a Dockerfile to build the Docker image of the Shiny app. Here is my example of a Dockerfile.

```
# Use a base image with R and Shiny Server pre-installed
FROM rocker/shiny-verse:latest

# Install system libraries for geospatial analysis
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libmysqlclient-dev

# Install R packages
RUN R -e "install.packages(c('shinyjs', 'shinyscreenshot', 'geosphere', 'raster', 'gstat', 'ggpubr', 'gridExtra', 'maps', 'rnpn','leaflet', 'terra','colorRamps', 'lubridate','digest','aws.s3','ptw','doSNOW','svglite','ggnewscale'), dependencies=TRUE)"

# Copy your Shiny app directory into the image
COPY <app name> /srv/shiny-server/<app name>

# Expose the default Shiny Server port
EXPOSE 3838
```

We can store this file at the root directory.

### Configure AWS ECR

We then set up an image repository in AWS ECR to store the Docker image of the Shiny app.

1. Go to the AWS Management Console and log in.
2. Search for **Elastic Container Registry** service and click **Create repository**. This is a private repository by default.
3. Set the image repository name and click **Create repository**. The container image URI should be in the format of `<AWS account number>.dkr.ecr.<AWS region>.amazonaws.com/<image repository name>:latest`.

### Configure AWS App Runner

We then set up a service in AWS App Runner that will run the Docker image of the Shiny app.

1. Go to the AWS Management Console and log in.
2. Search for **AWS App Runner** service and click **Create service**.
3. Choose **Container registry** as the repository type. Choose **Amazon ECR** as the provider. Set the container image URI by choosing the image repository name. Choose **Automatic** for the deployment trigger. Choose **using existing service role** of **AppRunnerECRAccessRole**. Click **Next**.
4. Set the service name, CPU and memory. Expose **Port** `3838` as this is what the Shiny app uses. Customize other configurations as needed. Click **Next**.
5. Review the settings and click **Create and deploy**. Note that the service ARN is in the form of `arn:aws:apprunner:<AWS region>:<AWS account number>:service/<app name>/<resource ID>`. Also note the default domain name of the service in the form of `<service ID>.<AWS region>.awsapprunner.com`.

### Configure IAM role

As we are using GitHub Actions, we need to set up an IAM role that allows GitHub to assume a role for deploying to AWS services. Follow the steps below to set up the IAM role.
[reference](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)

1. Go to the AWS Management Console and log in.
2. Search for **IAM** service and go to the IAM dashboard.
3. Navigate to **Access management** and **Identity providers**.
4. If there is not an identity provider called `token.actions.githubusercontent.com`, click on **Add provider** to create a new identity provider. For Provider type, choose OpenID Connect. For Provider URL, enter the URL of the GitHub OIDC IdP for this solution: `https://token.actions.githubusercontent.com`. For Audience, enter `sts.amazonaws.com`. This will allow the AWS Security Token Service (AWS STS) API to be called by this IdP. Add tag optionally. Click on **Add provider**.
5. Navigate to **Access management** and **Roles**. Click on **Create role**. Choose **Web identity** as the trusted entity type. Select `token.actions.githubusercontent.com` as the identity provider. Choose `sts.amazonaws.com` as the audience. Enter GitHub organization, GitHub repository, and GitHub branch that match the app we intend to deploy.
6. Add the necessary permission policies to the role. For ECR and App Runner, you can use the `AWSAppRunnerFullAccess`, `AWSAppRunnerServicePolicyForECRAccess`, and `AmazonEC2ContainerRegistryFullAccess` policies. Click on **Next**.
7. Name the role and edit the trust policy. Here is my example.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<aws account number>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": "repo:<GitHub organization>/<GitHub repository>:ref:refs/heads/<GitHub branch>"
                }
            }
        }
    ]
}
```
8. Review the role and click on **Create role**.
9. View the role and copy the ARN of the role.

### Setting up GitHub secrets

We need to store the ARN of the IAM role in GitHub Secrets. You will need the GitHub secret `AWS_ROLE_ARN`.

To add secrets to your repository:
1. Go to the repository's **Settings**.
2. Navigate to **Secrets**.
3. Click on **New repository secret** and add the relevant keys.

## Creating the GitHub Actions workflow

Now that we have the necessary credentials, we can create the GitHub Actions workflow to automate the build and deployment process.

Create a `.github/workflows/deploy.yml` file in your repository. Below is my example. This YAML file defines a GitHub Actions workflow with two jobs:

1. shinyapps-io: Deploys the Shiny app to shinyapps.io.
2. app-runner: Builds a Docker image and pushes it to AWS ECR.

```yaml
name: Build and Deploy Shiny App to AWS

on:
  push:
    branches:
      - main  # or the branch you want to deploy from
  pull_request:
    branches:
      - main

# Permission can be added at job level or workflow level    
permissions:
  id-token: write   # This is required for requesting the JWT
  contents: read    # This is required for actions/checkout

jobs:
  shinyapps-io:
    runs-on: ubuntu-latest

    container:
      image: rocker/shiny-verse:latest # Because we are going to deploy to shinyapps.io using R code, we here use an image with R and some R packages pre-installed
    
    steps:
    # Step 1: Checkout the code from GitHub
    - name: Checkout repository
      uses: actions/checkout@v3

    # Step 2: Install system dependencies
    - name: Install system dependencies # Note that this step is similar to one in the Dockerfile, because we are installing similar dependencies that the Shiny app requires
      run: |
        apt-get update
        apt-get install -y --no-install-recommends \
          libudunits2-dev \
          libgdal-dev \
          libgeos-dev \
          libproj-dev \
          libmysqlclient-dev

    # Step 3: Install R packages
    - name: Install R packages # Note that this step is similar to one in the Dockerfile, because we are installing similar dependencies that the Shiny app requires
      run: |
        Rscript -e "install.packages('rsconnect')"
        Rscript -e "install.packages(c('shinyjs', 'shinyscreenshot', 'geosphere', 'raster', 'gstat', 'ggpubr', 'gridExtra', 'maps', 'rnpn','leaflet', 'terra','colorRamps', 'lubridate','digest','aws.s3','ptw','doSNOW','svglite','ggnewscale'), dependencies = TRUE)"
            
    # Step 3: Deploy to shinyapps.io
    - name: Deploy to shinyapps.io # We use a while loop here to retry the deployment in case of failure, often because that the previous deployment is still in progress
      run: |
      
        retries=0
        max_retries=10
        while [[ $retries -lt $max_retries ]]
        do
          echo "Attempt $((retries + 1)) of $max_retries"
          Rscript -e "rsconnect::setAccountInfo(name='${{ secrets.SHINYAPPS_USER }}', token='${{ secrets.SHINYAPPS_TOKEN }}', secret='${{ secrets.SHINYAPPS_SECRET }}')" && \
          Rscript -e "rsconnect::deployApp(appDir = './phenowatch', appName = 'phenowatch', account = '${{ secrets.SHINYAPPS_USER }}', server = 'shinyapps.io', upload = T, forceUpdate = T)" && {
            echo "Deployment successful."
            break
          } || {
            echo "Deployment failed, retrying in 5 minutes..."
            sleep 300 # wait for 5 minutes before retrying
            retries=$((retries + 1))
          }
        done
      shell: bash # This is required because we are in a container but we are using bash syntax 
      env:
        RSCONNECT_USER: ${{ secrets.SHINYAPPS_USER }}
        RSCONNECT_TOKEN: ${{ secrets.SHINYAPPS_TOKEN }}
        RSCONNECT_SECRET: ${{ secrets.SHINYAPPS_SECRET }}

  app-runner:
    runs-on: ubuntu-latest
    
    steps:
    # Step 1: Checkout the code from GitHub
    - name: Checkout repository
      uses: actions/checkout@v3
        
    # Step 2: Set up AWS CLI
    - name: Set up AWS CLI
      uses: aws-actions/configure-aws-credentials@v3
      with:
        role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
        role-session-name: GitHub_to_AWS_via_FederatedOIDC
        aws-region: <AWS region>
    
    # Step 3: Build Docker image
    - name: Set up Docker
      uses: docker/setup-buildx-action@v3

    - name: Build Docker image
      run: |
        docker build -f Dockerfile -t <image repository name>:latest .

    # Step 4: Push Docker image to AWS ECR
    - name: Log in to Amazon ECR
      run: |
        aws ecr get-login-password --region <AWS region> | docker login --username AWS --password-stdin <AWS account number>.dkr.ecr.<AWS region>.amazonaws.com

    - name: Tag Docker image
      run: |
        docker tag <image repository name>:latest <AWS account number>.dkr.ecr.<AWS region>.amazonaws.com/<image repository name>:latest

    - name: Push Docker image to ECR
      run: |
        docker push <AWS account number>.dkr.ecr.<AWS region>.amazonaws.com/<image repository name>:latest

    # Step 5: Deploy to AWS App Runner
    # This step consists of resuming service, updating service, and pausing service. Omitting the details here. Please refer to GitHub repo for full code.
```

Push the changes to out repository to trigger the workflow. As the workflow is running, inspect the status by navigating to the **Actions** tab in our repository and selecting the most recent workflow. A successful workflow will be indicated by a green checkmark. If the workflow fails, you can click on the job to view the logs and debug the issue.

## Check deployed apps and debug

For the app hosted on shinyapps.io, you can navigate to your shinyapps.io account and view the deployed app. There you will find the url of the app in the form of `https://<username>.shinyapps.io/<appname>`. You can also use **Logs** tab to diagnose any issues.

For the app hosted on AWS App Runner, you can navigate to the AWS Management Console and go to the App Runner service. There you will find the url of the app in the form of `https://<service-id>.<AWS region>.awsapprunner.com`. You will need to add your Shiny app name to the end of the url `https://<service-id>.<AWS region>.awsapprunner.com/<shiny-app-name>`. You can also use the **Deployment logs** and **Application logs** to diagnose any issues.
