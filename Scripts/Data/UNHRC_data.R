################################################################################
###
###     NAME: Gleason Judd
###     DATE: 01/28/2014
###     WHAT: Set up data for the UNHRC project.
###     FILE: UNHRC_data.R
###
################################################################################

setwd("~/Google Drive/Research/IO_latent.engage/Data")

library(foreign)

#read in the complaint dataset.
full.dta <- read.dta("IOfull.dta")

#select variables of interest for response models.
attach(full.dta)
fullX <- data.frame(cbind(Country, Year, COWid, BinQualCode, StateDept, pop, rgdpl2, AL, JAL, UA, JUA, StInvite, 
           CountryMandate, CtryVisit, polity2, UNHRC, ED, FOOD,	FRDX,	HLTH,
           HOUSE, HRD, IJL, IND, MIG, RACE, RINT, SALE, SUMX, TOR, TOX, TRAF,	VAW))
detach(full.dta)

#read in country year dataset.
ctryyear <- read.dta("CtryYearIO.dta")

#select vars of interest for CompCount models.
attach(ctryyear)
ctryX <- data.frame(cbind(Country, Year, COWid, CompCount, StateDept, StInvite, CountryMandate, CtryVisit, rgdpl2, 
               LogPop, polity2))
detach(ctryyear)




