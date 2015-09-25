################################################################################
###
###   Response simulation for UNHRC engagement
###
###   Authors: Brad Smith, Gleason Judd
###   Created: 11/21/2014
###   Modified: 11/21/2014
###
###   Purpose: Generates simulated response data for comparison with 
###            observed responses as a posterior predictive check.
###   
###
################################################################################

rm(list = ls())
require(foreign)
require(rstan)
require(ggplot2)
### Set WD, load in Rstan results
setwd("~/Google Drive/Research/IO_latent.engage")
load("Data/engagement_v3.RData")
load("Output/UNHRCfit.RData")
load("Output/output.data.RData")
UNHRCfit <- extract(fit)

engsim <- function(ccode, # Cow ID
                   year,  # Year of simulation
                   n      # Number of simulations
){
  # First generate the observed distribution
  ID <- year * 1000 + ccode
  colcount <- A[which(EngID == ID)]
  observed <- X[which(EngID == ID), c(1:colcount)]
  
  # Next, simulate n responses, first generate probabilities
  e <- exp(as.vector(Betas[1,])*(output.data$theta[which(EngID == ID)] -
                                       as.vector(alphas[1,])))
  probs <- c(rep(0, length(e)))
  for(i in 1:length(probs)){
    probs[i] <- e[i]/sum(e)
  }
  probs <- as.numeric(probs)
  
  # Now, simulate using the sample command
  sim <- sample(c(1:length(probs)),
                n,
                replace = TRUE,
                prob = probs)
  
  # Now make data frames and create ggplots
  country <- output.data$Country[which(output.data$EngID == ID)]
  simtitle <- paste("Histogram of simulated responses,", country, year)
  simplot.data <- as.data.frame(sim)
  simplot <- ggplot(data = simplot.data,
                    aes(x = sim,
                        fill = ..count..)) + geom_histogram(binwidth = 1,
                                                            origin = 1)
  simplot <- simplot + ggtitle(simtitle) + xlab("Simulated Response")
  simplot <- simplot + scale_x_continuous(breaks = 0:6)

  
 # Now make the observed plot
 obs.data <- as.data.frame(observed)
 obstitle <- paste("Histogram of observed responses,", country, year)
 obsplot <- ggplot(data = obs.data,
                   aes(x = observed,
                       fill = ..count..)) + geom_histogram(binwidth = 1,
                                                           origin = 1)
 obsplot <- obsplot + ggtitle(obstitle) + xlab("Observed Response")
 obsplot <- obsplot + scale_x_continuous(breaks = 0:6)

 # Return plots
 print(simplot)
 print(obsplot)
}


#Test it out with Iran 2004
engsim(ccode = 630,
       year = 2004,
       n = 100000)
