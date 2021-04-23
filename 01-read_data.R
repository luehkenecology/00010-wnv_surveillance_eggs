# set working directory
RPROJ <- list(PROJHOME = normalizePath(getwd()))
attach(RPROJ)
rm(RPROJ)
setwd(PROJHOME)

# read table greece
data_greece <- read.table("data/processed/wnv_results_eggs_greece.csv", header = T, sep = ";")
