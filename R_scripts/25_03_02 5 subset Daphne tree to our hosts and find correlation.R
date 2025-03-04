library(picante)
library(tidyr)
library(dplyr)
library(ape)
library(ggplot2)
library(ggtree)
library(stringr)

# import and wrangle data -------------------------------------------------------------

tree <- read.tree("data/Daphne/DaPhnE_01.tre")
taxa <- tree$tip.label

data <- read.csv("data/symbiont_count.csv")
data <- data %>%
  arrange(desc(no_symbionts)) %>%
  mutate(host_name = str_replace(host_name, " ", "_"))

# subset tree to our hosts -----------------------------------------------

subset_tree <- keep.tip(tree, taxa[taxa %in% data$host_name])
length(subset_tree$tip.label) / length(tree$tip.label)
# 0.3328778

ggtree(subset_tree)


# calculate average phylogenetic distance ---------------------------------

phylo_distance_matrix <- cophenetic(subset_tree)
phylo_distance_matrix <- data.frame(phylo_distance_matrix)
phylo_distance_matrix$host_name <- rownames(phylo_distance_matrix)

phylo_distance <- phylo_distance_matrix %>%
  rowwise() %>%
  mutate(ave_phylo_distance = sum(c_across(1:411))/411) %>%
  select(host_name, ave_phylo_distance)


# merge dataframes --------------------------------------------------------

total_data <- merge(data, phylo_distance, by="host_name")


# is there a pattern? -----------------------------------------------------

plot <- ggplot(data = total_data, aes(ave_phylo_distance, no_symbionts), log="y") +
  geom_point() +
  xlab('Average Phylogenetic Distance') +
  ylab('Number of Invertebrate Symbionts')

plot
plot + scale_y_continuous(trans='log10')

cor(total_data$ave_phylo_distance, total_data$no_symbionts, method = 'pearson')
# 0.04052991
