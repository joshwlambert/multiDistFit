#' Maximum likelihood fitting of multiple distributions
#'
#' @param data A numeric vector of values
#' @param models A character string or vector of character strings
#' specifying the names of the candidate models. This follows the R naming
#' convention for distributions, the density function is `d[name]`.
#'
#' @return A data frame of all models
#' @export
#'
#' @examples
#' multi_fitdist(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c("gamma", "weibull", "lnorm")
#' )
multi_fitdist <- function(data, models) {

  # fit distributions to data
  if (is.data.frame(data)) {
    if (ncol(data) == 2) {
      res <- lapply(
        models,
        fitdistrplus::fitdistcens,
        censdata = data
      )
    } else {
      res <- fit_cdt_dist(data = data, models = models)
      # data is formatted in fit_cdt_dist so return early
      return(res)
    }
  } else {
    res <- lapply(
      models,
      fitdistrplus::fitdist,
      data = data
    )
  }

  # extract loglikelihood, aic and bic
  loglik <- sapply(res, "[[", "loglik")
  aic <- sapply(res, "[[", "aic")
  bic <- sapply(res, "[[", "bic")

  # package results into data frame
  res <- data.frame(models = models, loglik = loglik, aic = aic, bic = bic)

  # order the results from best fit to worst
  res <- res[order(res$aic, method = "radix"), ]
  rownames(res) <- NULL

  # return results
  res
}

#' Calculates the goodness-of-fit statistics for the fitted distributions
#'
#' @inheritParams multi_fitdist
#'
#' @return A `gofstat.fitdist` object from the `{fitdistrplus}` package
#' @export
#'
#' @examples
#' goodness_of_fit(
#'   data = rgamma(n = 100, shape = 1, scale = 1),
#'   models = c('gamma', 'weibull', 'lnorm')
#' )
goodness_of_fit <- function(data, models) {

  fitdist <- vector("list", length(models))
  # fit distributions to data
  if (is.data.frame(data)) {
    fitdist <- lapply(
      models,
      fitdistrplus::fitdistcens,
      censdata = data
    )
  } else {
    fitdist <- lapply(
      models,
      fitdistrplus::fitdist,
      data = data
    )
  }

  # return the goodness-of-fit statistics for each model
  fitdistrplus::gofstat(fitdist, fitnames = models)
}

#' Fits probability distributions using `coarseDataTools::dic.fit()`
#'
#' @inheritParams multi_fitdist
#'
#' @return A data frame of all models
#' @export
#'
#' @examples
#' library(coarseDataTools)
#' data("nycH1N1")
#' fit_cdt_dist(data = nycH1N1, models = c("lnorm", "weibull"))
fit_cdt_dist <- function(data, models) {

  # convert models to format accepted by dic.fit()
  models <- gsub(pattern = "lnorm", replacement = "L", x = models)
  models <- gsub(pattern = "gamma", replacement = "G", x = models)
  models <- gsub(pattern = "weibull", replacement = "W", x = models)

  fitdist <- lapply(models, function(x, data) {
    if (x == "G") {
      # gamma distribution fitting requires bootstrapping
      coarseDataTools::dic.fit(dat = data, dist = x, n.boots = 100)
    } else {
      coarseDataTools::dic.fit(dat = data, dist = x)
    }
  }, data)

  # extract loglikelihood
  loglik <- sapply(fitdist, "slot", "loglik")

  # calculate aic and bic
  aic <- calc_aic(loglik)
  bic <- calc_bic(loglik, data)

  # change models back to original
  models <- gsub(pattern = "^L$", replacement = "lnorm", x = models)
  models <- gsub(pattern = "^G$", replacement = "gamma", x = models)
  models <- gsub(pattern = "^W$", replacement = "weibull", x = models)

  # package results into data frame
  res <- data.frame(models = models, loglik = loglik, aic = aic, bic = bic)

  # order the results from best fit to worst
  res <- res[order(res$aic, method = "radix"), ]
  rownames(res) <- NULL

  # return results
  res
}

#' Calculates the Akaike information criterion for the loglikelihood of a two
#' parameter probability distribution
#'
#' @param loglik A vector or single number the loglikelihood of the model
#'
#' @return A single or vector of numerics equal to the input vector length
#' @export
#'
#' @examples
#' calc_aic(loglik = -110)
calc_aic <- function(loglik) {

  # make loglik a logLik class for AIC method
  class(loglik) <- "logLik"

  # set degrees of freedom (TODO: allow df to change)
  attr(loglik, "df") <- 2

  # calculate and return AIC
  stats::AIC(loglik)
}

#' Calculates the Bayesian information criterion for the loglikelihood of a two
#' parameter probability distribution
#'
#' @inheritParams calc_aic
#' @inheritParams multi_fitdist
#'
#' @return A single or vector of numerics equal to the input vector length
#' @export
#'
#' @examples
#' library(coarseDataTools)
#' data("nycH1N1")
#' calc_bic(loglik = -110, data = nycH1N1)
calc_bic <- function(loglik, data) {

  # make loglik a logLik class for BIC method
  class(loglik) <- "logLik"

  # set degrees of freedom (TODO: allow df to change)
  attr(loglik, "df") <- 2

  # set number of observations
  attr(loglik, "nobs") <- nrow(data)

  # calculate and return BIC
  stats::BIC(loglik)

}
