library(ggplot2)
library(reshape)
library(scales)
library(RColorBrewer)
library(dplyr)
library(ggh4x)
library(directlabels)

all<-read.csv(file="./p2_speedup.csv",header=TRUE,sep=",")
all$Threads<-factor(all$Threads, levels=c("1","2","4","8"))
all <- filter(all, all$mode == "RT")

p<-ggplot(data=all, aes(x = Threads, y = Time, group=Workload, color=Workload)) + 
	geom_line(aes(linetype = Workload)) + 
	geom_point() +
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("Speedup for different workloads\n[x Times]") +
	labs(x = "#Threads", y = "") +
	theme(axis.text.x = element_text(family = "Helvetica",
	  		face = "plain",
	  		colour = "black",
	  		size = 10,),
	    axis.text.y = element_text(family = "Helvetica",
	  		face = "plain",
	  		colour = "black",
	  		size = 10,
	  		angle = 0),
	    axis.title.x = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p2_r2.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))