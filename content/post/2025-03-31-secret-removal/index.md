---
title: "Secret removal from GitHub repository"
author: "Yiluan Song"
date: "2025-03-31"
output: html_document
---

## Introduction

Recently, I received a notification that my GitHub repository contains a secret. A secret is a sensitive information that should not be shared publicly, including passwords, API keys, and tokens. We should avoid storing secrets in a GitHub repository to prevent unauthorized access, even when the repository is private. It is not sufficient to simply delete the secret from the repository, as the commit history may still contain the secret. In this blog, I will demonstrate how to remove secrets from a GitHub repository.

## Scan for secrets

I use [GitGuardian](https://www.gitguardian.com/) to scan for secrets in my GitHub repositories. GitGuardian can be integrated with GitHub to automatically scan for secrets in repositories.

You would need to sign up for GitGuardian and authorize access to your GitHub repositories. Once the integration is set up, GitGuardian will scan the repositories you own (could be those in an organization) for secrets.

In the "Monitored perimeter" section, I can see the repositories that have been scanned, with their health status being "At risk" or "Safe."

If you click on a repository, you can see the secrets that have been detected. For each secret, you can see the file path, the type of secret, and the commit that introduced the secret.

## Remove secrets

You can still remove the leaked API key from your Git commit history, but simply deleting or modifying the file in a new commit won’t be enough.

We can use the tool `git-filter-repo` to remove the secret from the commit history. First, install the tool by running the following command in the terminal.

```bash
pip install git-filter-repo
```

Alternatively, you can install the tool directly to the folder of your choice.

```bash
mkdir -p <path for installation>
cd <path for installation>
curl -LO https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo
chmod +x git-filter-repo
export PATH=<path for installation>:$PATH
```

Check if you have the tool installed correctly.

```bash
git filter-repo --version
```

You need to clone the repository as a mirror repository. Note that if you already have this repository cloned in your local environment and have been working on it, you should push your changes and delete this local clone, because we need to work on a fresh clone of the repository.

```bash
cd <where you usually store your GitHub repositories>
git clone --mirror https://github.com/<your username or organization name>/<your repo>.git
```
When you use the `git clone --mirror` command, you might notice that the repo is detached from the remote repository. This is normal.

We will then go into this repository and use the `git filter-repo` command to remove the secret. Replace `<your-secret-key>` with the actual secret you want to remove. You should have obtained the leaked secret from GitGuardian just now. It could be a password, an API key, or a token. If you have multiple secrets to remove, repeat the `git filter-repo` command for each secret.

```bash
cd <your repo>
git filter-repo --replace-text <(echo "<your-secret-key>==>REMOVED")
```

Now that we have cleaned the local repository, we will re-add the remote and force push the cleaned repository.

```bash
git remote add origin https://github.com/<your username or organization name>/<your repo>.git
git push --force --all
```

## Wrap up

You are strongly suggested to revoke the leaked secret and generate a new one. Do this in the service where the secret was generated. For example, if it was an API key for Google Cloud, you should revoke the key in the Google Cloud Console and generate a new one.

Back in your repository, You should update the secret, as well as how it is used. Do not write the secret in your code. You might want to use environment variables or a secret manager to store the secret.

Here is an example of using environment variables to connect to an account for `shinyapps.io` in R.

```r
# Load existing .env file (if it exists)
dotenv::load_dot_env(".env")

# Check each required variable and prompt if missing
name <- check_and_prompt_env("RSCONNECT_NAME", "Enter shinyapps.io name: ")
token <- check_and_prompt_env("RSCONNECT_TOKEN", "Enter shinyapps.io token: ")
secret <- check_and_prompt_env("RSCONNECT_SECRET", "Enter shinyapps.io secret: ")

# Reload .env file to ensure new values are available
dotenv::load_dot_env(".env")

# Set account info
rsconnect::setAccountInfo(
  name = name,
  token = token,
  secret = secret
)
```

Now you can go to GitGuardian and mark the incident(s) as resolved. You can select the repository and click "Scan" to make sure you have removed all secrets successfully.
