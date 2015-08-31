



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

# Pull out unique values of the ID and sort them
EngID <- sort(unique(eng$ID))


X <- list(NA)

# Populate a list of each country-year's responses ordered
for (i in 1:length(EngID)){
  
  # Subset original matrix for the given ID variable
  sub <- eng[eng$ID==EngID[i],]
  
  # Fill in rows of X object with corresponding Quality Scores
    X[[i]] <- as.vector(sub$QualCode)
}

# turn the list into a long vector
Y <- X[[1]]

for (i in 2:length(X)){
  Y <- c(Y,X[[i]])
}


# Now generate a count of responses for each country year, ordered as Y is
A <- rep(0,length(X))
for (i in 1:length(X)){
  A[i] <- length(X[[i]])
}

# Generate a counter for use in the stan loop. This object is a two-column matrix
# such that the first column is the first place in Y that the stan loop needs to grab and 
# the second column is the last for each country-year
Counter <- matrix(NA,length(A),2)
Counter[1,1] <- 1
Counter[1,2] <- A[1]
for (i in 2:length(A)){
  Counter[i,1] <- Counter[i-1,2]+1
  Counter[i,2] <- Counter[i,1]+A[i]-1
}


# Now generate complaint counts for each country year
cyear$ID <- cyear$Year*1000+cyear$COWid
Z <- as.data.frame(cyear[,c("ID",
                            "CompCount")])

CountID <- Z$ID

Z <- Z$CompCount

# Clear Workspace, save data object
rm(list=setdiff(ls(),c("Y","Z","EngID", "CountID","Counter")))

# Save this as object engagement.R
save.image("~/Google Drive/IO_latent.engage/Data/engagement_v2.Rdata")



