library(stringr)
library(tidyr)
library(dplyr)
library(ape) # for tree stuff

# import and wrangle data -------------------------------------------------------------
data <- read.csv("data/symbiont_count.csv")
data <- data %>%
  arrange(desc(no_symbionts))

tree <- read.tree("data/Parker_et_al_2018_dated_tree.txt")


## extract genus names only ------------------------------------------------
host_genera <- str_extract(data$host_name, '[A-Za-z]+')
host_genera <- host_genera %>%
  unique() %>%
  tolower()

## check format correct - at least some should be in Parker data!--------------------------
taxa <- tree$tip.label
TRUE %in% (host_genera %in% taxa)

host_genera %in% taxa
sum(host_genera %in% taxa)
length(host_genera)

# comparing the datasets --------------------------------------------------
## what fraction of genera are in Parker data?---------------------------------------------
sum(host_genera %in% taxa)/length(host_genera)
# 0.22973728

## which genera?----------------------------------------------------------------------------
host_genera[host_genera %in% taxa]

# lump taxa to genus ------------------------------------------------------
host_names <- data$host_name %>%
  tolower()

sum(host_genera %in% host_names)
# 1214

genus_data <- data %>%
  mutate(genus = tolower(str_extract(data$host_name, '[A-Za-z]+'))) %>%
  select(genus, no_symbionts) %>%
  group_by(genus) %>%
  summarise(no_symbionts = sum(no_symbionts))

sum(genus_data$genus %in% taxa)
# 411/1784 = 0.23038117

write.csv(genus_data, file="data/genus_symbionts.csv", row.names = FALSE)
