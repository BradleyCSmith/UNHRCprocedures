################################################################################
###
###   Summary statistics for UNHRC analysis
###
###   Authors: Brad Smith, Gleason Judd
###   Created: 1/27/2016
###   Modified: 1/27/2016
###
###
################################################################################

rm(list = ls())
require(ggplot2)
require(MASS)
setwd("~/Google Drive/Research/IO_latent.engage/Data")
load("FullUnique.Rdata")

# First do some summaries of response types for varying allegation types
# FOOD, FRDX, HLTH, HOUSE, SUMX, TOR, TRAF, 

# First, code a variable that indicates response vs no response
# (this counts in translation as no response)
full.uniq$response <- as.numeric(as.logical(full.uniq$QualCode != 1 & full.uniq$QualCode != 6))


sum.sumx <- full.uniq$QualCode[full.uniq$SUMX == 1]
hist(sum.sumx)

sumr.sumx <- full.uniq$response[full.uniq$SUMX == 1]
hist(sumr.sumx)

sum.hlth <- full.uniq$QualCode[full.uniq$HLTH == 1]
hist(sum.hlth)

sumr.hlth <- full.uniq$response[full.uniq$HLTH == 1]
hist(sumr.hlth)

sum.tor <- full.uniq$QualCode[full.uniq$TOR == 1]
hist(sum.tor)

sumr.tor <- full.uniq$response[full.uniq$TOR == 1] 
hist(sumr.tor)

# Chi-squared test of independence for allegation type vs response type
# Reject null of independence
tbl <- table(full.uniq$ResponseScore, full.uniq$QualityScore)
chisq.test(tbl)

# Now look at joint vs. non-joint allegations
# Reject null of independence
full.uniq$joint <- as.numeric(as.logical(full.uniq$CommunicationType == "JUA" |
                                           full.uniq$CommunicationType == "JAL"))

tbl <- table(full.uniq$ResponseScore, full.uniq$joint)
chisq.test(tbl)

### Now look at response vs. no response, using t tests to compare
### response rates for sub populations

# Test whether various subsets have different response rates
# First standing invitation
# Results suggest that states with standing invitation are more likely to respond
stand <- full.uniq$response[full.uniq$StInvite == 1]
nostand <- full.uniq$response[full.uniq$StInvite != 1]
hist(stand)
hist(nostand)
var.test(stand, nostand)
t.test(stand, nostand, var.equal = TRUE, paired = FALSE)

# Next, country mandate.
# We reject null that they are different. Note that countries with 
# a mandate are less likely to respond. 
mand <- full.uniq$response[full.uniq$CountryMandate == 1]
nomand <- full.uniq$response[full.uniq$CountryMandate != 1]
hist(mand)
hist(nomand)
var.test(mand, nomand)
t.test(mand, nomand, var.equal = FALSE, paired = FALSE)

# Look closer at ones with a mandate

