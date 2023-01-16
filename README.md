
# multiDistFit

<!-- badges: start -->
[![R-CMD-check](https://github.com/joshwlambert/multiDistFit/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/joshwlambert/multiDistFit/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/joshwlambert/multiDistFit/branch/main/graph/badge.svg)](https://app.codecov.io/gh/joshwlambert/multiDistFit?branch=main)
[![Lifecycle: deprecated](https://img.shields.io/badge/lifecycle-deprecated-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#deprecated)
[![Project Status: Abandoned – Initial development has started, but there has not yet been a stable, usable release; the project has been abandoned and the author(s) do not intend on continuing development.](https://www.repostatus.org/badges/latest/abandoned.svg)](https://www.repostatus.org/#abandoned)
<!-- badges: end -->

### This package is a proof-of-concept and is now deprecated. To use the functionality to fit multiple distribution models see the [`{quickfit}`](https://github.com/epiverse-trace/quickfit) package as part of the [Epiverse](https://data.org/initiatives/epiverse/) initiative.

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

