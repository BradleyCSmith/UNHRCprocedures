


rm(list = ls())
require(ggplot2)
require(MASS)
require(mlogit)
require(foreign)
setwd("~/Google Drive/Research/IO_latent.engage/Data")
load("FullUnique.Rdata")
full <- read.dta("IOfull.dta")


# Need to make a summary statistics table first


# Run a multinomial logit
# Define choice variable after removing missing responses
full.uniq <- full.uniq[is.na(full.uniq$QualCode) == FALSE,]
full.uniq$choice <- factor(full.uniq$QualCode)
#full.uniq <- full.uniq[full.uniq$TORT == 1,]

data <- mlogit.data(full, shape = "wide", choice = "QualCode")

# Subset to torture allegations
data <- full.uniq[full.uniq$TORT == 1, c("choice",
                                         "CountryMandate",
                                         "polity",
                                         "StInvite",
                                         "rgdpl")]
data <- as.matrix(data)
data <- as.data.frame(data)
row.names(data) <- c(1:nrow(data))
shape <- mlogit.data(data, shape = "wide", choice = "choice")
mnl <- mlogit(choice ~ 0 | CountryMandate + StInvite + rgdpl,
              data = shape)
summary(mnl)


# Hausman test for IIA


# Write separate script for mixed logit because it might take a little while
# to run. 