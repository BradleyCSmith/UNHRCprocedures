rm(list=ls())
library(rstan)
library(foreign)

# Set directory
setwd("~/Google Drive/IO_latent.engage")

### Load in data
load("Data/engagement_v2.Rdata")

# Create the stan data object
N <- length(Y)
M <- length(Z)
d <- nrow(Counter)

eng.stan.data <- list(N=N,
                      M=M,
                      Y = Y,
                      K = 6,
                      Z = Z,
                      D = Counter,
                      d = d,
                      beta1 <- 0
                      )

engage.stan <- '
data{
int<lower=1> N;    //length of Y
int<lower=1> M;    //length of Z 
int<lower=1> d;    //length of D
int<lower=1> K;    //number of responses 
int Y[N];      //create X
int Z[M];        //create Z
int D[d,2];      //create D, which is a counter for the model loop to grab the correct parameters
}

parameters{
vector<lower=0>[K] B;     //set the question discrimintation parameter
vector[N] theta;          //set the country engagement parameter
vector<lower=0>[M] eta;   //set the UNHRC country concern parameter
vector[K] alpha;              //set an intercept for the responses
}

model{
B ~ lognormal(0,1);
eta ~ lognormal(0,1);
theta ~ normal(0,1);

Z ~ poisson(eta);


for (i in 1:N){
        Y[D[i,1]:D[i,2]] ~ categorical(softmax(alpha + B*theta[i]));
    }
  }
}
'

fit <- stan(model_code = engage.stan,
            data = eng.stan.data,
            iter = 5,
            chains = 1)
