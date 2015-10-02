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

load("engagement_catissue_noit.Rdata")

# Create the stan data object
N <- nrow(X)


eng.stan.data <- list(N=N,                   # Number of rows in X
                      A=A,                   # Number of responses for a c/year
                      X = X,                 # Response data matrix
                      Y = Y,                 # Issue data matrix
                      K = 5,                 # Number of response categories
                      I = 3,                # Number of issue categories
                      L = ncol(X)            # Size of X
                      )

engage.stan <- "
data{
int<lower=1> N;    //number of rows in X
int<lower=1> L;    //number of columns of X
int<lower=1> K;    //number of responses categories
int<lower=1> I;    //number of issue categories
int A[N];          //create A, number of responses for each c/year
int X[N,L];      //create X, response data matrix
int Y[N,L];      // create Y, issue data matrix
}

parameters{
matrix[I,K] B;     //set the question discrimination parameter
vector[N] theta;          //set the country engagement parameter
matrix[I,K] alpha;              //set an ``difficulty'' for the responses, by issue
}



model{
B[1,1] ~ lognormal(0,1);
for(i in 2:K){
  B[1,i] ~ normal(0,3);
}
for(i in 2:I){
  B[i] ~ normal(0,3);
}
theta ~ normal(0,1);
for(i in 1:I){
alpha[i] ~ normal(0,10);
}
for (i in 1:N){
    for (j in 1:A[i]){
        X[i,j] ~ categorical_logit(B[Y[i,j]]' .* alpha[Y[i,j]]' - B[Y[i,j]]' * theta[i]);
    }
  }
}
"
iter <- 10000
fit <- stan(model_code = engage.stan,
            data = eng.stan.data,
            iter = iter,
            chains = 3,
            warmup = floor(iter/4))

#UNHRCfit <- extract(fit)
rm(list = setdiff(ls(),c("fit")))

save.image("Output/UNHRCfit_issue.RData")

