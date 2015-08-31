################################################################################
###
###   Data processing for UNHRC engagement project
###
###   Authors: Brad Smith, Gleason Judd
###   Created: 11/21/2014
###   Modified: 11/21/2014
###
###   Purpose: Transforms Rstan MCMC output to a usable form
###   
###
################################################################################

rm(list=ls())
require(foreign)

### Set WD, load in Rstan results
setwd("~/Google Drive/Research/IO_latent.engage")
load("Data/engagement_10k_3chain.RData")

### Load in full dataset to extract ID information (e.g. year, COW code)
data <- read.dta("Data/IOfull.dta")
eng <- as.data.frame(cbind(data[,c("Country",
                                   "Year",
                                   "COWid")]))
ID.data <- unique(eng[c("Country","Year","COWid")])
ID.data$EngID <- ID.data$Year*1000+ID.data$COWid

# Bind means from estimation to Engagement ID values
thetas <- est$theta
thetas <- colMeans(thetas,dims=1)
thetas <- as.data.frame(cbind(EngID,
                              thetas))

# Merge the full data with the theta means
output.data <- merge(ID.data,
                     thetas,
                     by = intersect(names(ID.data),names(thetas)))

rm(list=setdiff(ls(),"output.data"))




