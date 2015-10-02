################################################################################
###
###
###   Stan code for UNHRC engagement project, Version 4
###   Authors: Gleason Judd, Brad Smith
###
###
###   Purpose: Updated stan code to include scaling of variables ala Gelman 2005
###            This version also omits estimation of UNHCR concern levels.
###
################################################################################

rm(list=ls())

library(rstan)
library(foreign)

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# Set directory
#setwd("~/Google Drive/Research/IO_latent.engage")

### Load in data, this uses the third version of the data, created in
### the script create_data_vs.R

load("engagement_v3.Rdata")

# Create the stan data object
N <- nrow(X)


eng.stan.data <- list(N=N,                   # Number of rows in X
                      A=A,                   # Number of responses for a c/year
                      X = X,                 # Response data matrix
                      K = 6,                 # Number of response categories
                      L = ncol(X)            # Size of X
                      )

engage.stan <- "
data{
int<lower=1> N;    //number of rows in X
int<lower=1> L;    //number of columns of X
int<lower=1> K;    //number of responses categories
int A[N];          //create A, number of responses for each c/year
int X[N,L];      //create X, response data matrix
}

parameters{
vector[K] B;     //set the discrimination parameters
vector[N] theta;          //set the country engagement parameter
vector[K] alpha;              //set an ``difficulty'' for the responses, by issue
}

model{
B[1] ~ lognormal(0,1);
for(i in 2:K){
B[i] ~ normal(0,3);
}
theta ~ normal(0,5);
alpha ~ normal(0,5);
for (i in 1:N){
    for (j in 1:A[i]){
        X[i,j] ~ categorical_logit(B*theta[i] - B .* alpha);
    }
  }
}
"
iter <- 10000
fit <- stan(model_code = engage.stan,
            data = eng.stan.data,
            iter = iter,
            chains = 3,
            warmup = floor(iter/3))

#UNHRCfit <- extract(fit)
rm(list = setdiff(ls(),c("fit")))

save.image("Output/UNHRCfitbase1.RData")

