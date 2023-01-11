#' Fits multiple distributions
#'
#' @param data A numeric vector of values
#' @param models A character string or vector of character strings
#' specifying the names of the candidate models. This follows the R naming
#' convention for distributions, the density function is `d[name]`.
#' @param method A character string for the method of model fitting.
#' See `?fitdistrplus::fitdist` for details.
#'
#' @return A data frame of all models
#' @export
#'
#' @examples
#' stub
multi_fitdist <- function(data, models, method = "mle") {

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
      data = data,
      method = method
    )
  }

  # extract loglikelihood, aic and bic
  loglik <- sapply(fitdist, "[[", "loglik")
  aic <- sapply(fitdist, "[[", "aic")
  bic <- sapply(fitdist, "[[", "bic")

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
#' stub
goodness_of_fit <- function(data, models, method = "mle") {
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
      data = data,
      method = method
    )
  }

  # return the goodness-of-fit statistics for each model
  fitdistrplus::gofstat(fitdist, fitnames = models)
}
