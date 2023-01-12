# A script that checks whether the censorred model fitting from {fitdistrplus}
# and {coarseDataTools} returns the same parameters and model likelihoods
# for the same model on the same data

library(fitdistrplus)
library(coarseDataTools)
data("salinity")
data("nycH1N1")

# format of fitdistrplus data is a 2 col data frame that has:
# - left: either NA or left censorred observations, the left bound of the
# interval censorred observations, or the obserted value for non-censorred
# observations
# - right: either NA for right censorred observations, the right bound of the
# interval for interval censorred observations, or the observed value for
# non-censorred observations
head("salinity")

# format of coarseDataTools data is a 5 col data frame that has:
# - EL: the earliest possible time of infection
# - ER: the latest possible time of infection
# - SL: the earliest possible time of symptom onset
# - SR: the latest possible time of symptom onset
# - type: an indicator of the type of observation: 0 for doublhy interval-
# censorred, 1 for single-interval censorred, 2 for exact.
head(nycH1N1)


# compare methods without censorring
EL <- rpois(n = 100, lambda = 1)
ER <- EL + 0.1
SL <- EL + rpois(n = 100, lambda = 2) + 0.1
SR <- SL + 0.1
mock_cdt_data <- data.frame(
  EL = EL,
  ER = ER,
  SL = SL,
  SR = SR,
  type = 2
)

mock_fdp_data_full <- data.frame(
  left = EL,
  right = SL
)

cdt_res <- dic.fit(dat = mock_cdt_data, dist = "L")
fdp_res <- fitdistcens(censdata = mock_fdp_data_full, distr = "lnorm")

cdt_res@loglik
fdp_res$loglik

# compare methods with right-censorring
