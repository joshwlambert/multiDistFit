% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fitdist.R
\name{calc_bic}
\alias{calc_bic}
\title{Calculates the Bayesian information criterion for the loglikelihood of a two
parameter probability distribution}
\usage{
calc_bic(loglik, data)
}
\arguments{
\item{loglik}{A vector or single number the loglikelihood of the model}

\item{data}{A numeric vector of values}
}
\value{
A single or vector of numerics equal to the input vector length
}
\description{
Calculates the Bayesian information criterion for the loglikelihood of a two
parameter probability distribution
}
\examples{
library(coarseDataTools)
data("nycH1N1")
calc_bic(loglik = -110, data = nycH1N1)
}
