rm(list=ls())
library(rstan)
library(foreign)

# Set directory
setwd("~/Google Drive/IO_latent.engage")

### Load in data
load("Data/engagement.Rdata")

# Create the stan data object
N <- nrow(X)
M <- length(Z)


eng.stan.data <- list(N=N,
                      M=M,
                      A=A,
                      X = X,
                      K = 6,
                      Z = Z,
                      L = ncol(X),
                      beta1 <- 0
                      )

engage.stan <- '
data{
int<lower=1> N;    //number of rows in X
int<lower=1> M;    //length of Z 
int<lower=1> K;    //number of responses 
int<lower=1> L;    //number of columns of X
int A[N];          //create A
int X[N,L];        //create X
int Z[M];          //create Z
}

parameters{
vector<lower=0>[K] B;     //set the question discrimintation parameter
vector[N] theta;          //set the country engagement parameter
vector<lower=0>[M] eta;   //set the UNHRC country concern parameter
}

model{
B ~ lognormal(0,1);
eta ~ lognormal(0,1);

Z ~ poisson(eta);

for (i in 1:N){
  for (j in 1:A[i]){
        X[i,j] ~ categorical(softmax(B*theta[i]));
    }
  }
}
'

fit <- stan(model_code = engage.stan,
            data = eng.stan.data,
            iter = 5,
            chains = 1)
