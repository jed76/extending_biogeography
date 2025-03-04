library(dplyr)
library(tidyr)
library(BiodiversityR)

data <- read.csv("data/symbiont_count.csv")

data <- data %>%
  arrange(desc(no_symbionts))

plot(data$no_symbionts, log='xy')
