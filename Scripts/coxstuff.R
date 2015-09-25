################################################################################
###
###
###   Code to execute Cox PH models and preliminaries on complaint dataset.
###   Authors: Gleason Judd, Brad Smith
###
###
###   Purpose: In description. 
###            
###
################################################################################



rm(list=ls())
library(survival)
library(foreign)
setwd("~/Google Drive/Research/IO_latent.engage")

data <- read.dta("Data/IOfull.dta",convert.underscore=TRUE)
attach(data)

surv1 <- Surv(duration1,censored,type='right')

#### WORK TO DO FROM HERE DOWN  #####

#Create matrix of independent variables.  JUA left out, VAW left out.
X1 <- cbind(AL,JAL,UA,ED,FOOD,FRDX,HLTH,HOUSE,HRD,IJL,IND,MIG,RACE,RINT,SALE,
        SUMX,TOR,TOX,TRAF)
X2 <- cbind(AL,JAL,UA)
coxfit1 <- coxph(surv1 ~ X2,ties="efron")
testph <- cox.zph(coxfit1)
kapcurve1 <- survfit(coxfit1,newdata = )


