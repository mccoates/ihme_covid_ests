


cols <- brewer.pal(name="Blues",n=9)[c(2,3,4,5,7,9)]

pdf(paste0(data_dir,"model_version_comparison.pdf"),width=8,height=6)

gg <- ggplot(data=d[location_name %in% c("United States of America")],aes(x=date_form,y=totdea_mean,group=model_version,color=model_version)) + geom_line(size=1.1) + theme_bw() +
  scale_x_date("Date",date_breaks="1 month",date_labels="%b %d") + 
  ylab("Deaths (mean)")  +
  scale_color_manual("Model Version",values=cols) #+ theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(gg)

dev.off()

pdf(paste0(data_dir,"model_version_comparison_states_facet.pdf"),width=26,height=12)

gg <- ggplot(data=d[!location_name %in% c("United States of America")],aes(x=date_form,y=totdea_mean,group=model_version,color=model_version)) + geom_line(size=1.1) + theme_bw() +
  facet_wrap(~location_name,scales="free") + scale_x_date("Date",date_breaks="1 month",date_labels="%b %d") +  ylab("Deaths (mean)") + 
  scale_color_manual("Model Version",values=cols) #+ theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(gg)

dev.off()


