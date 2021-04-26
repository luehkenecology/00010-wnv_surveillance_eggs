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
library(tidyverse)

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
  summarise(total_n =sum(sum))
            
#
data_greece3 <- data_greece2 %>%
  group_by(Regional.Unit, week, classified.as, .drop = F) %>%
  summarise(n = sum(sum),
            perc = sum(sum)/nrow(data_greece)*100) %>%
  group_by(Regional.Unit, week) %>%
  mutate(sum_region_week = sum(n)) %>%
  group_by(Regional.Unit) %>%
  mutate(sum_region = sum(n))




head(data.frame(data_greece3))

data_greece4 <- rbind(data.frame(data_greece3[,c(1:4,7)]),
      data.frame(data_greece3[,1:2],
                 classified.as = "tested",
                 n = data_greece3$sum_region_week,
                 sum_region = data_greece3$sum_region))

# table per regionl unit
ost <- data_greece4 %>%
  group_by(Regional.Unit, classified.as) %>%
  summarise(sum = sum(n))%>%
  spread(classified.as, sum)
write.table(cbind(ost[,1:4],
                  tested = rowSums(ost[,2:4])), "ost.csv", sep = ";", col.names = NA)

data_greece4$classified.as <- factor(data_greece4$classified.as, levels = rev(c("tested","WNV negative", "doubtful", "WNV positive")))

# figure phenology
data_greece4 %>%
  filter(sum_region > 100 & classified.as %in% c("tested", "doubtful", "WNV positive")) %>%
  ggplot(aes(week, n, color = classified.as)) +
  geom_point()+
  geom_line() +
  ylab("number of eggs") +
  xlab("calendar week") +
  facet_wrap(~Regional.Unit) +
  scale_color_manual(values=rev(c("black", "yellow", "red")))+
  theme_bw()