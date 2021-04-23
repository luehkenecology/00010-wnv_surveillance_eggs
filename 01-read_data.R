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
  group_by(Regional.Unit, Municipality, Village, classified.as, week) %>%
  summarise(sum = length(classified.as))
  
# percentage 
data_greece2 %>%
  group_by(classified.as) %>%
  summarise(n =sum(sum),
            perc = sum(sum)/nrow(data_greece)*100)

# calculate the total number of eggs per regional unit
total_eggs_region <- data_greece2 %>%
  group_by(Regional.Unit) %>%
  summarise(total_n =sum(sum))

# calculate the total number of eggs per regional unit and calender week
total_eggs_region <- data_greece2 %>%
  group_by(Regional.Unit) %>%
  summarise( =sum(sum))
            
#
data_greece3 <- data_greece2 %>%
  group_by(Regional.Unit, week, classified.as) %>%
  summarise(n = sum(sum),
            perc = sum(sum)/nrow(data_greece)*100)

data_greece4 <- merge(data_greece3, total_eggs_region, by = "Regional.Unit")
data_greece4$total_n
library(ggplot2)

data_greece4$classified.as <- factor(data_greece4$classified.as, levels = rev(c("WNV negative", "doubtful", "WNV positive")))


data_greece4 %>%
  filter(total_n > 100) %>%
  ggplot(aes(week, n, fill = classified.as)) +
  geom_bar(stat='identity') +
  #geom_line(aes(color = classified.as))+
  #geom_point(aes(color = classified.as))+
  #geom_line() +
  ylab("number of eggs") +
  xlab("calendar week") +
  facet_wrap(~Regional.Unit) +
  scale_fill_manual(values=rev(c("black", "yellow", "red")))+
  theme_bw()
