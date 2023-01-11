
# multiDistFit

<!-- badges: start -->
[![R-CMD-check](https://github.com/joshwlambert/multiDistFit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/joshwlambert/multiDistFit/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/joshwlambert/multiDistFit/branch/main/graph/badge.svg)](https://app.codecov.io/gh/joshwlambert/multiDistFit?branch=main)
<!-- badges: end -->

The goal of multiDistFit is to allow comparison of multiple model comparison 
when fitting distributions to censorred and non-censorred data. The package is
a wrapper to other packages (e.g. `{fitdistrplus}` and `{coarseDataTools}`) 
which carry out the model fitting.

## Installation

You can install the development version of multiDistFit from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("joshwlambert/multiDistFit")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(multiDistFit)

## basic example code
multi_fitdist(
  data = rlnorm(n = 100, meanlog = 1, sdlog = 1), 
  models = c("lnorm", "gamma", "weibull")
)
```

