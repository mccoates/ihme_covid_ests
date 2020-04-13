## Matthew Coates
## Compile estimate versions

rm(list=ls())
library(data.table)
library(ggplot2)
library(stringr)
library(RColorBrewer)
library(dplyr)

data_dir <- paste0(getwd(),"/estimates/")

## identify folders of different version dates
folds <- dir(data_dir)
folds <- folds[!grepl(".pdf",folds)]

## load in estimates -- some variables named differently across datasets, so fix these
d <- lapply(folds,FUN=function(x) {
  cat(paste0(x)); flush.console()
  fl <- dir(paste0(data_dir,x),pattern=".csv")
  out <- fread(paste0(data_dir,x,"/",fl))
  ## some appear to have a row number column
  if (!is.null(out$V1)) out[,V1:=NULL]
  ## name of folder that the dataset came from as model version
  out[,model_version:=x]
  ## variable names can be different across datasets -- "date reported" is used instead of "date" for first two releases, make these consistent
  if (x %in% folds[c(1:4)]) setnames(out,"date_reported","date")
  ## location_name seems to be used in all of them, but location introduced in more recent ones
  out[,location:=location_name]
  ## seems like two different US names in different versions of data
  out[location_name=="US",location_name:="United States of America"]
  
  ## add date downloaded
  dd <- read.table(paste0(data_dir,x,"/download_date_time.txt"),sep=" ")
  out[,date_downloaded:=dd$V1]
  
  ## add IHME estimate date from website
  ii <- read.table(paste0(data_dir,x,"/ihme_estimate_date.txt"),sep=" ")
  out[,ihme_estimate_date:=ii$V1]
})

d <- rbindlist(d,use.names=T)

d[,date:=as.Date(date)]
d[,date_downloaded:=as.Date(date_downloaded)]
d[,ihme_estimate_date:=as.Date(ihme_estimate_date)]

## clean up variables duplicated through changing of formats
d[,c("location"):=NULL]

## what is going on with 2020-04-08 version?
## I downloaded a folder called "2020_04_07.04.all originally 
## the mean total deaths, new ICUs, and admissions seem to be consistent (from a quick comparison of means) with those that I downloaded later when IHME posted their old estimates 
## so I will use those and drop those titled "2020_04_07.04.all"
## given that those haven't been posted by IHME as an old set, and "2020_04_07.06.all" are the ones they have posted for the version 2020-04-08
d <- d[!model_version %in% c("2020_04_07.04.all")]


## Write the results to an output/ folder
write.csv(d, file="output/compiled_estimates.csv",row.names = F)

# Save a dataset for the model comparison visualization
# https://observablehq.com/@mkfreeman/ihme-model-comparisons
d %>% 
  select(location_name, date, model_version, icuover_mean, deaths_mean, bedover_mean) %>% 
  write.csv(file="output/model_comparison_data.csv", row.names = F)

#saveRDS(d, file="output/compiled_estimates.rds")




