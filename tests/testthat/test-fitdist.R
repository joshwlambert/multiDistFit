test_that("multi_fitdist works as expected on vector", {
  res <- multi_fitdist(
    data = rlnorm(n = 100, meanlog = 1, sdlog = 1),
    models = c("lnorm", "gamma", "weibull")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 4)
})

test_that("multi_fitdist works as expected on censorred data", {
  library(fitdistrplus)
  data("salinity")
  res <- multi_fitdist(
    data = salinity,
    models = c("lnorm", "gamma", "weibull")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 4)
})

test_that("goodness_of_fit works as expected on vector", {
  res <- goodness_of_fit(
    data = rlnorm(n = 100, meanlog = 1, sdlog = 1),
    models = c("lnorm", "gamma", "weibull")
  )
  expect_s3_class(res, "gofstat.fitdist")
})

test_that("multi_fitdist works as expected on vector", {
  library(coarseDataTools)
  data("nycH1N1")
  res <- multi_fitdist(
    data = nycH1N1,
    models = c("lnorm", "weibull")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 2)
  expect_equal(ncol(res), 4)
})
