
nameLookup <- read.csv("data/BSBI_PA2020_10by10kmSquareData/nameLookup.csv")
taxon <- nameLookup$ddbidLookup[1] # take ID of first taxon in database
taxon <- "2cd4p9h_13q"

taxonDistribution <- read.csv(paste("data/BSBI_PA2020_10by10kmSquareData/hectadDistributions/", taxon, ".csv", sep=""))

taxonDistribution$hectad # list of hectads where taxon is present
