################################################################################
###
###     Plot generator for UNHRC engagement. 
###     Created: 9/23/2015
###     Last Modified: 9/23/2015
###     Author: B C Smith
###
###     Script for user-friendly plot generation.
###
###     Inputs: 
###     COMPARE = A vector of COW country codes for states to be used in plot
###     STYEAR = First year for comparison.
###     ENDYEAR = Last year for comparison. 
###
###     
################################################################################

require(ggplot2)

### Set WD
setwd("~/Google Drive/Research/IO_latent.engage")
load("Output/output.data.RData")


plotmaker <- function(compare, 
                      styear, 
                      endyear){

Year <- c(styear:endyear)
# Create time series dataset
ts <- output.data[output.data$COWid %in% compare,]
ts <- ts[ts$Year %in% Year,]

tsplot <- qplot(Year, theta, data = ts, colour = Country) 
tsplot <- tsplot + geom_smooth(aes(ymin = theta80lower,
                                  ymax = theta80upper),
                              data = ts,
                              stat = "identity")
tsplot <- tsplot + theme_bw() + ggtitle("Posterior Mean and 80% Credible Interval")
tsplot <- tsplot + ylab(expression(theta)) + xlab("Year") 
return(tsplot) }


# Compare US and Canada from 2004-2008 just for kicks. 
plotmaker(compare = c(2,   #USA
                      20), #Canada
          styear = 2004,
          endyear = 2008
          )
