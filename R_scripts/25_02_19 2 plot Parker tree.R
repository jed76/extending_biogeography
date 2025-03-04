library(ape)
library(ggplot2)
library(ggtree)

tree <- read.tree("data/Parker_et_al_2018_dated_tree.txt")
# plot(tree)

ggtree(tree)

# check if a given element is in the tree
"glossocardia" %in% tree$tip.label

taxa <- tree$tip.label

"quercus" %in% taxa
