library(picante)
library(tidyr)
library(dplyr)
library(ape)
library(ggplot2)
library(ggtree)

# import data -------------------------------------------------------------

tree <- read.tree("data/Parker_et_al_2018_dated_tree.txt")
taxa <- tree$tip.label
genus_data <- read.csv("data/genus_symbionts.csv")


# subset tree to our genera -----------------------------------------------

subset_tree <- keep.tip(tree, taxa[taxa %in% genus_data$genus])

ggtree(subset_tree)


# calculate average phylogenetic distance ---------------------------------

phylo_distance_matrix <- cophenetic(subset_tree)
phylo_distance_matrix <- data.frame(phylo_distance_matrix)
phylo_distance_matrix$genus <- rownames(phylo_distance_matrix)

phylo_distance <- phylo_distance_matrix %>%
  rowwise() %>%
  mutate(ave_phylo_distance = sum(c_across(1:411))/411) %>%
  select(genus, ave_phylo_distance)


# merge dataframes --------------------------------------------------------

total_data <- merge(genus_data, phylo_distance, by="genus")


# is there a pattern? -----------------------------------------------------

plot <- ggplot(data = total_data, aes(ave_phylo_distance, no_symbionts), log="y") +
  geom_point() +
  xlab('Average Phylogenetic Distance') +
  ylab('Number of Invertebrate Symbionts')

plot
plot + scale_y_continuous(trans='log10')

cor(total_data$ave_phylo_distance, total_data$no_symbionts, method = 'pearson')
# 0.12385275


# save figures ------------------------------------------------------------

png('figures/25_02_19_symbionts_vs_phylo_distance.png', height=2500, width=3000, res=600, bg='white')

plot

dev.off()

png('figures/25_02_19_symbionts_vs_phylo_distance_log.png', height=2500, width=3000, res=600, bg='white')

plot + scale_y_continuous(trans='log10')

dev.off()
