# Load required libraries
library(tidyverse)
library(spBayes)
library(sp)
library(gstat)

### Read in example spatial data
data(meuse)
data <- meuse %>%
  drop_na() %>%
  mutate(n = row_number()) %>%
  rowwise() %>%
  mutate(group = sample(c("train", "valid"), 1)) %>%
  ungroup()
head(data)

### Fit spatial model
fit.spLM <- function(data) {
  spdata <- data.frame(x = data$x, y = data$y, X1 = data$elev, X2 = data$landuse, response = data$copper)
  coordinates(spdata) <- spdata[, c("x", "y")]
  
  coords <- as.matrix(data[, c("x", "y")])
  colnames(coords) <- c("longitude", "latitude")
  
  # Preparing to run spatial model; get lognormal model phi (spatial decay parameter) estimate
  fit.nonspLM <- lm(response ~ X1 + X2, spdata) # fit non-spatial model
  n_predictor <- fit.nonspLM$coefficients %>% length() # get number of predictors
  z <- resid(fit.nonspLM) # residuals of non-spatial model
  spdata$z <- z
  test.vgm <- gstat::variogram(z ~ 1, data = spdata)
  test.fit <- gstat::fit.variogram(test.vgm, model = gstat::vgm("Exp"))
  phi <- test.fit[2, ]$range # extract phi value from fitted variogram
  
  # Set priors: loose priors on beta and residual error variance (tausq), and on spatial variance parameter (sigma.sq), but very tight on Phi (spatial decay parameter).
  priors <- list("beta.Norm" = list(rep(0, n_predictor), diag(100, n_predictor)), "phi.Unif" = c(-log(0.05) / (phi * 100), -log(0.05) / (phi / 100)), "sigma.sq.IG" = c(2, 2), "tau.sq.IG" = c(2, 0.1)) # shape and scale for IG
  # Set starting and tuning values
  starting <- list("phi" = -log(0.05) / phi, "sigma.sq" = 50, "tau.sq" = 1)
  tuning <- list("phi" = (log(0.05) / (phi * 100) - log(0.05) / (phi / 100)) / 10, "sigma.sq" = 0.01, "tau.sq" = 0.01)
  
  # Knots for spatial model
  # knots = kmeans(coords, 20,iter.max=100)$centers
  
  # Run spatial model
  splm <- spLM(response ~ X1 + X2,
               data = spdata,
               coords = coords,
               cov.model = "exponential",
               priors = priors,
               tuning = tuning,
               starting = starting,
               n.samples = 10000,
               n.report = 1000 # ,
               # knots = knots
  )
  
  return(splm)
}

splm <- fit.spLM(data = data %>% filter(group == "train"))

### Parameter inference
splm.recover <- function(model) {
  # Recover parameter samples, ignoring the first half of the run as burn-in.
  splm <- spRecover(model,
                    get.beta = TRUE,
                    get.w = F,
                    start = 5001,
                    n.report = 1000
  )
  beta.hat <- splm$p.beta.recover.samples
  # theta.hat <- splm$p.theta.recover.samples
  
  df_param <- beta.hat %>%
    data.frame() %>%
    mutate(i = row_number()) %>%
    gather(key = "param", value = "value", -i)
  
  # Plot posterior
  p_posterior <- df_param %>%
    ggplot() +
    geom_density(aes(x = value)) +
    facet_wrap(. ~ param, scales = "free") +
    theme_classic() +
    geom_vline(xintercept = 0, col = "red")
  
  # Coefficient summaries
  df_summary <- df_param %>%
    group_by(param) %>%
    summarise(
      median = median(value),
      lower = quantile(value, 0.025, names = F),
      upper = quantile(value, 0.975, names = F)
    ) %>%
    mutate(sig = case_when(
      lower * upper < 0 ~ "ns",
      TRUE ~ "*"
    ))
  
  out <- list(
    p_posterior = p_posterior,
    df_summary = df_summary
  )
  
  return(out)
}

sp_param <- splm.recover(splm)
sp_param$p_posterior
sp_param$df_summary

### Cross validation
splm.cv <- function(model, data) {
  data <- data_valid
  
  spdata <- data.frame(x = data$x, y = data$y, X1 = data$elev, X2 = data$landuse, response = data$copper)
  coordinates(spdata) <- spdata[, c("x", "y")]
  
  coords <- as.matrix(data[, c("x", "y")])
  colnames(coords) <- c("longitude", "latitude")
  
  mat_design <- model.matrix(response ~ X1 + X2, data = spdata) %>%
    data.frame() %>%
    mutate(n = row_number()) %>%
    gather(key = "predictor", value = "value", -n) %>%
    group_by(n) %>%
    mutate(predictor = fct_expand(predictor, model$X %>%
                                    data.frame() %>%
                                    colnames())) %>%
    complete(predictor, fill = list(value = 0)) %>% # complete dataframe with new levels
    ungroup() %>%
    spread(key = "predictor", value = "value") %>%
    select(all_of(model$X %>%
                    data.frame() %>%
                    colnames())) %>%
    as.matrix()
  
  
  sp_pred <- spPredict(model,
                       pred.covars = mat_design,
                       pred.coords = coords,
                       start = 5001
  )
  
  df_predict <- sp_pred$p.y.predictive.samples %>%
    data.frame() %>%
    mutate(n = row_number()) %>%
    gather(key = "i", value = "value", -n) %>%
    group_by(n) %>%
    summarise(
      median = median(value),
      lower = quantile(value, 0.025, names = F),
      upper = quantile(value, 0.975, names = F)
    ) %>%
    bind_cols(obs = spdata$response)
  
  p_predict <- df_predict %>%
    ggplot() +
    geom_point(aes(x = obs, y = median)) +
    geom_errorbar(aes(x = obs, ymin = lower, ymax = upper)) +
    geom_smooth(aes(x = obs, y = median), method = "lm") +
    ggpubr::stat_cor(aes(x = obs, y = median)) +
    theme_classic() +
    labs(
      x = "Observation",
      y = "Prediction"
    )
  
  out <- list(
    df_predict = df_predict,
    p_predict = p_predict
  )
  
  return(out)
}

sp_cv <- splm.cv(splm, data = data %>% filter(group == "valid"))
sp_cv$p_predict
