
rm(list=ls())
library(data.table)
library(ggplot2)

d <- fread("output/compiled_estimates.csv")

## identify states and US based on locations from model published before adding extra locations
locs <- unique(d[date_downloaded == "2020-03-27"]$location_name)

## limit to US locations
d <- d[location_name %in% locs]

## convert dates to date format
d[,date:=as.Date(date)]
d[,date_downloaded:=as.Date(date_downloaded)]
d[,ihme_model_date:=factor(as.Date(ihme_model_date))]


## identify how many model versions are in dataset
num_mods <- length(unique(d$model_version))

if (num_mods <= 9) {
  cols <- brewer.pal(name="Blues",n=9)[(10-num_mods):9]
} else {
  cols <- brewer.pal(name="Blues",n=9)
  ## if more than 9 models in dataset, plot most recent 9
  d <- d[ihme_model_date %in% sort(unique(d$ihme_model_date))[(num_mods-8):num_mods]]
}


pdf(paste0("output/model_version_comparison.pdf"),width=8,height=6)

gg <- ggplot(data=d[location_name %in% c("United States of America")],aes(x=date,y=totdea_mean,group=ihme_model_date,color=ihme_model_date)) + geom_line(size=1.1) + theme_bw() +
  scale_x_date("Date",date_breaks="1 month",date_labels="%b %d") + 
  ylab("Deaths (mean)")  +
  scale_color_manual("Model Version",values=cols) #+ theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(gg)

dev.off()

pdf(paste0("output/model_version_comparison_states_facet.pdf"),width=28,height=12)

gg <- ggplot(data=d[!location_name %in% c("United States of America")],aes(x=date,y=totdea_mean,group=ihme_model_date,color=ihme_model_date)) + geom_line(size=1.1) + theme_bw() +
  facet_wrap(~location_name,scales="free") + scale_x_date("Date",date_breaks="1 month",date_labels="%b %d") +  ylab("Deaths (mean)") + 
  scale_color_manual("Model Version",values=cols) #+ theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(gg)

dev.off()


