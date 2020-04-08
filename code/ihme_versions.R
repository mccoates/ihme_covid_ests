## Matthew Coates
## Compile estimate versions

rm(list=ls())
library(data.table)
library(ggplot2)
library(stringr)
library(RColorBrewer)

data_dir <- paste0(getwd(),"/estimates/")

## identify folders of different version dates
folds <- dir(data_dir)
folds <- folds[!grepl(".pdf",folds)]

## load in estimates -- some variables named differently across datasets, so fix these
d <- lapply(folds,FUN=function(x) {
  fl <- dir(paste0(data_dir,x),pattern=".csv")
  out <- fread(paste0(data_dir,x,"/",fl))
  ## some appear to have a row number column
  if (!is.null(out$V1)) out[,V1:=NULL]
  ## name of folder that the dataset came from as model version
  out[,model_version:=x]
  ## variable names can be different across datasets -- "date reported" is used instead of "date" for first two releases, make these consistent
  if (x %in% folds[c(1:2)]) setnames(out,"date_reported","date")
  ## location_name seems to be used in all of them, but location introduced in more recent ones
  out[,location:=location_name]
})

d <- rbindlist(d,use.names=T)

## seems like two different US names
d[location_name=="US",location_name:="United States of America"]
d[,date_form:=as.Date(date)]

## clean up variables duplicated through changing of formats
d[,c("location"):=NULL]

## Write the results to an output/ folder
write.csv(d, file="output/compiled_estimates.csv",row.names = F)
