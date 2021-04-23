# set working directory
RPROJ <- list(PROJHOME = normalizePath(getwd()))
attach(RPROJ)
rm(RPROJ)
setwd(PROJHOME)

# read table greece
data_greece <- read.table("data/processed/wnv_results_eggs_greece.csv", header = T, sep = ";")

# libraries
library(magrittr)
library(dplyr)

# number of tested eggs
nrow(data_greece)

# 
data_greece2 <- data_greece %>%
  group_by(Regional.Unit, Municipality, Village, classified.as) %>%
  summarise(sum = length(classified.as))
  
# percentage 
data_greece2 %>%
  group_by(classified.as) %>%
  summarise(n =sum(sum),
            perc = sum(sum)/nrow(data_greece)*100)
