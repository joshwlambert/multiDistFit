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
    res <- lapply(
      models,
      fitdistrplus::fitdistcens,
      censdata = data
    )

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
