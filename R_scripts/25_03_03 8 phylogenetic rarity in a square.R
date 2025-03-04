library(stringr)

nameLookup <- read.csv("data/BSBI_PA2020_10by10kmSquareData/nameLookup.csv")
taxonlist <- unique(nameLookup$ddbidLookup)


taxon <- nameLookup$ddbidLookup[1] # take ID of first taxon in database
taxon <- "2cd4p9h_13q"

taxonDistribution <- read.csv(paste("data/BSBI_PA2020_10by10kmSquareData/hectadDistributions/", taxon, ".csv", sep=""))

taxonDistribution$hectad # list of hectads where taxon is present


# add phylodistance taxon names to lookup list ----------------------------

nameLookup$phyloLookup <- sub(" ", "_", nameLookup$taxonName)



# get list of squares -----------------------------------------------------
taxon <- "2cd4p9h_xbs" # Bellis perennis
taxonDistribution <- read.csv(paste("data/BSBI_PA2020_10by10kmSquareData/hectadDistributions/", taxon, ".csv", sep=""))

hectadlist <- unique(taxonDistribution$hectad)


# taxon list for a square -------------------------------------------------

hectad <- "X99"
hectadSpeciesList <- c()
counter = 0
for(taxon in taxonlist){
  print(paste(counter, "out of 3497", sep = " "))
  taxonDistribution <- read.csv(paste("data/BSBI_PA2020_10by10kmSquareData/hectadDistributions/", taxon, ".csv", sep=""))
  
  hectadSpeciesList <- rbind(hectadSpeciesList, c(taxon, hectad %in% taxonDistribution$hectad))
  counter = counter + 1
}
write.csv(hectadSpeciesList, paste("data/BSBI_PA2020_10by10kmSquareData/hectadSpeciesLists/", hectad, ".csv", sep=""))


# taxon list for all squares ----------------------------------------------

hectadlist <- hectadlist[-c(1:10)] # remove hectads that we have already done
hectadlistlength <- length(hectadlist)

hectadCounter <- 1
for(hectad in hectadlist){
  hectadSpeciesList <- c()
  taxonCounter = 1
  for(taxon in taxonlist){
    if(taxonCounter %% 100 == 0){
      print(paste(taxonCounter, "out of 3497 taxa", sep = " "))
    }
    taxonDistribution <- read.csv(paste("data/BSBI_PA2020_10by10kmSquareData/hectadDistributions/", taxon, ".csv", sep=""))
    
    if(hectad %in% taxonDistribution$hectad){ # if present, include abundance (number of distinct hectads)
      hectadSpeciesList <- rbind(hectadSpeciesList, c(taxon, TRUE, taxonDistribution[taxonDistribution$hectad == hectad,]$distinct.tetrads))
    }
    else{ # if absent, abundance = 0
      hectadSpeciesList <- rbind(hectadSpeciesList, c(taxon, FALSE, 0))
    }
    taxonCounter = taxonCounter + 1
  }
  write.csv(hectadSpeciesList, paste("data/BSBI_PA2020_10by10kmSquareData/hectadSpeciesLists/", hectad, ".csv", sep=""))  
  hectadCounter = hectadCounter + 1
  print(paste(hectadCounter, "out of", hectadlistlength, "hectads", sep = " "))
}

# for a given taxon, calculate phylogenetic rarity in a square ------------
taxon <- "2cd4p9h_xq4"

B60 <- read.csv("data/BSBI_PA2020_10by10kmSquareData/hectadSpeciesLists/B60.csv")
B60 <- B60[B60$V2,] # remove absent taxa
# is taxon present?
taxon %in% B60$V1

taxon1_phylo_matrix_name <- nameLookup[nameLookup$ddbidLookup == taxon,]$phyloLookup

for(taxon2 in B60$V1){
  taxon2_phylo_matrix_name <- nameLookup[nameLookup$ddbidLookup == taxon2,]$phyloLookup
  print(paste(taxon1_phylo_matrix_name, taxon2_phylo_matrix_name))
  print(phylo_distance_matrix[taxon1_phylo_matrix_name, taxon2_phylo_matrix_name])
}
