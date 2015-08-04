



rm(list=ls())
library(foreign)
setwd("~/Google Drive/IO_latent.engage")

data <- read.dta("Data/IOfull.dta")
cyear <- read.dta("Data/CtryYearIO.dta")



####### Build Dataset ########

# Subset full data to include only needed Variables in engagement dataset
eng <- as.data.frame(cbind(data[,c("Country",
                                   "Year",
                                   "COWid",
                                   "QualCode")]))



# Generate country year ID, sort data by this
eng$ID <- eng$Year*1000+eng$COWid
order.eng <- eng[order(eng$ID),]



# Pull out identifier for the loop
EngID <- sort(unique(eng$ID))

X <- matrix(0,length(EngID),max(cyear$CompCount))


for (i in 1:length(EngID)){
  
  # Subset original matrix for the given ID variable
  sub <- eng[eng$ID==EngID[i],]
  
  # Fill in rows of X object with corresponding Quality Scores
  for(j in 1:length(sub$QualCode)){
    X[i,j] <- sub$QualCode[j]
  }
}

# Now generate a count of responses for each country year
A <- rep(0,nrow(X))
for (i in 1:nrow(X)){
  A[i] <- sum(as.numeric(as.logical(X[i,]>0)))
}

# Now generate complaint counts for each country year
# This is for use in the poisson, not needed for stan_v4

cyear$ID <- cyear$Year*1000+cyear$COWid
Z <- as.data.frame(cyear[,c("ID",
                            "CompCount")])

CountID <- Z$ID

Z <- Z$CompCount

# Clear Workspace, save data object
rm(list=setdiff(ls(),c("X","Z","EngID", "CountID","A")))

# Save this as object engagement.R
save.image("~/Google Drive/IO_latent.engage/Data/engagement_v3.Rdata")



