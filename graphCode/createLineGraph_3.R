# Plots Figure 1 (number of architecture-specific and architecture-independent builtins per project)

library(ggplot2)
library(reshape)
library(scales)
library(RColorBrewer)
library(dplyr)
library(ggh4x)
library(directlabels)

if(FALSE){
 
	theme(axis.line=element_blank(),
	      axis.text.x=element_blank(),
	      axis.text.y=element_blank(),
	      axis.ticks=element_blank(),
	      axis.title.x=element_blank(),
	      axis.title.y=element_blank(),
	      legend.position="none",
	      panel.background=element_blank(),
	      panel.border=element_blank(),
	      panel.grid.major=element_blank(),
	      panel.grid.minor=element_blank(),
	      plot.background=element_blank())
}
p1<-read.csv(file="./p3_1.csv",header=TRUE,sep=",")
p2<-read.csv(file="./p3_2.csv",header=TRUE,sep=",")
p3<-read.csv(file="./p3_3.csv",header=TRUE,sep=",")

p<-ggplot(data=p1, aes(x = time, y = p95)) + 
	geom_line() + 
	geom_point() +
	scale_y_continuous(labels=function(x)x/1000) +
	geom_vline(xintercept=8, linetype="dashed", color = "red3", size=0.3) +
	geom_text(aes(x=10, label="start dedup\nstart ferret\nstart freqmine\nstart blackscholes", y=250, hjust=0), colour="red3", angle=0, size=4 ) +
	geom_vline(xintercept=140, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_text(aes(x=142, label="start canneal", y=925, hjust=0), colour="darkgoldenrod3", angle=0, size=4 ) +
	geom_vline(xintercept=203, linetype="dashed", color = "darkolivegreen4", size=0.3) +
	geom_text(aes(x=205, label="start fft", y=1000, hjust=0), colour="darkolivegreen4", angle=0, size=4 )+  xlim(0,320) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("95th percentile latency\n[ms]") +
	labs(x = "Time [s]", y = "") +
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

ggsave(filename="./P3_1.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

p<-ggplot(data=p2, aes(x = time, y = p95)) + 
	geom_line() + 
	geom_point() +
	scale_y_continuous(labels=function(x)x/1000) +
	geom_vline(xintercept=6, linetype="dashed", color = "red3", size=0.3) +
	geom_text(aes(x=8, label="start dedup\nstart ferret\nstart freqmine\nstart blackscholes", y=250, hjust=0), colour="red3", angle=0, size=4 ) +
	geom_vline(xintercept=116, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_text(aes(x=118, label="start canneal", y=1000, hjust=0), colour="darkgoldenrod3", angle=0, size=4 ) +
	geom_vline(xintercept=227, linetype="dashed", color = "darkolivegreen4", size=0.3) +
	geom_text(aes(x=229, label="start fft", y=1000, hjust=0), colour="darkolivegreen4", angle=0, size=4 ) +  xlim(0,320) +
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("95th percentile latency\n[ms]") +
	labs(x = "Time [s]", y = "") +
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

ggsave(filename="./P3_2.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

p<-ggplot(data=p3, aes(x = time, y = p95)) + 
	geom_line() + 
	geom_point() +
	scale_y_continuous(labels=function(x)x/1000) +
	geom_vline(xintercept=6, linetype="dashed", color = "red3", size=0.3) +
	geom_text(aes(x=8, label="start dedup\nstart ferret\nstart freqmine\nstart blackscholes", y=200, hjust=0), colour="red3", angle=0, size=4 ) +
	geom_vline(xintercept=109, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_text(aes(x=111, label="start canneal", y=1000, hjust=0), colour="darkgoldenrod3", angle=0, size=4 ) +
	geom_vline(xintercept=209, linetype="dashed", color = "darkolivegreen4", size=0.3) +
	geom_text(aes(x=211, label="start fft", y=1000, hjust=0), colour="darkolivegreen4", angle=0, size=4 ) + xlim(0,320) +
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("95th percentile latency\n[ms]") +
	labs(x = "Time [s]", y = "") +
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

ggsave(filename="./P3_3.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))