################################################################################
###
###
###   Stan code for UNHRC engagement project, Version 4
###   Authors: Gleason Judd, Brad Smith
###
###   Created: 11/12/2014
###   Last modified: 11/12/2014
###   
###
###   Purpose: Updated stan code to include scaling of variables ala Gelman 2005
###            This version also omits estimation of UNHCR concern levels.
###
################################################################################

rm(list=ls())
library(rstan)
library(foreign)

# Set directory
setwd("~/Google Drive/IO_latent.engage")

### Load in data, this uses the third version of the data, created in
### the script create_data_vs.R

load("Data/engagement_v3.Rdata")

# Create the stan data object
N <- nrow(X)


eng.stan.data <- list(N=N,                   # Number of rows in X
                      A=A,                   # Number of responses for a c/year
                      X = X,                 # Response data matrix
                      K = 6,                 # Number of response categories
                      L = ncol(X)            # Size of X
                      )

engage.stan <- '
data{
int<lower=1> N;    //number of rows in X
int<lower=1> L;    //number of columns of X
int<lower=1> K;    //number of responses categories
int A[N];          //create A, number of responses for each c/year
int X[N,L];      //create X, response data matrix
}

parameters{
vector[K] B;     //set the question discrimintation parameter
vector[N] theta;          //set the country engagement parameter
vector[K] alpha;              //set an intercept for the responses
}

transformed parameters{
vector[K] B_trans;
vector[N] theta_trans;
vector[K] alpha_trans;

B_trans <- (B - mean(alpha)) / sd(alpha); 
theta_trans <- (theta - mean(alpha)) / sd(alpha) ;
theta_trans[586] <- -1;
alpha_trans <- (alpha - mean(alpha)) / sd(alpha);
}

model{
B ~ normal(0,3);
theta ~ normal(0,3);
alpha ~ normal(0,3);

for (i in 1:N){
    for (j in 1:A[i]){
        X[i,j] ~ categorical(softmax(alpha_trans + B_trans*theta_trans[i]));
    }
  }
}
'

fit <- stan(model_code = engage.stan,
            data = eng.stan.data,
            iter = 1000,
            chains = 2,
            warmup = floor(iter/3))
