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

p4_1<-read.csv(file="./p4_5_1.csv",header=TRUE,sep=",")
p4_2<-read.csv(file="./p4_5_2.csv",header=TRUE,sep=",")
p4_3<-read.csv(file="./p4_5_3.csv",header=TRUE,sep=",")
p4_1_cores<-read.csv(file="./p4_5_1_cores.csv",header=TRUE,sep=",")
p4_2_cores<-read.csv(file="./p4_5_2_cores.csv",header=TRUE,sep=",")
p4_3_cores<-read.csv(file="./p4_5_3_cores.csv",header=TRUE,sep=",")

#1A
p<-ggplot(data=p4_1, aes(x = time)) + 
	geom_step(aes(y = QPS/25), colour="darkolivegreen3") + 
	geom_step(aes(y = p95), colour="dodgerblue3") + 
	annotate("text", x=-35, label="p95", y=150, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-35, label="QPS", y=400, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=-10, label="p95", y=150, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=-10, label="QPS", y=400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	annotate("text", vjust=0.5, hjust=0, x=38, label="fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=34, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=67, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=67, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=80, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=82, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=84, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=88, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=92, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=92, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=94, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=94, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=96, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=97, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=99, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=123, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=123, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=144, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=144, linetype="dashed", color = "darkgoldenrod3", size=0.3) + 
	annotate("text", vjust=1, hjust=1, x=209, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=209, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=254, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=254, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=265, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=265, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=275, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=275, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=287, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=287, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=310, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=310, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=315, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=315, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=317, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=364, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=364, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=400, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=410, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=474, label="dedup", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=474, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1170, label="blackscholes", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1170, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=423, label="ferret", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=423, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1380, label="freqmine", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1380, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=16, label="canneal", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=16, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4000), xlim = c(-35, 1700), clip = "off") + xlim(-35, 1700) +
	
	#geom_hline(yintercept=2000, linetype="dashed", 
    #            color = "red", size=0.5) + 
	
	scale_y_continuous(
		labels=function(x)x/1000,

		sec.axis = sec_axis(~.*25,
			name = "QPS",
			labels=function(y) paste0(y/1000, "k")),
		) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("1A\n\n") +
	labs(x = "Time [s]", y = "95th percentile latency [ms]") +
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
	    axis.title.y = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    axis.title.y.right = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12,
	  		angle = 90),
	  	plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p4_5_1a.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

#1B
p<-ggplot(data=p4_1, aes(x = time)) + 
	geom_step(data = p4_1_cores, aes(x = time, y = nr_cores), colour="dodgerblue3") + 
	geom_step(aes(y = QPS/25000), colour="darkolivegreen3") + 
	annotate("text", x=-45, label="#cores", y=1.5, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-40, label="QPS", y=0.2, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +

#fft
	annotate("text", vjust=0.5, hjust=0, x=38, label="fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=34, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=67, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=67, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=80, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=82, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=84, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=88, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=92, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=92, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=94, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=94, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=96, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=97, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=99, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=123, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=123, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=144, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=144, linetype="dashed", color = "darkgoldenrod3", size=0.3) + 
	annotate("text", vjust=1, hjust=1, x=209, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=209, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=254, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=254, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=265, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=265, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=275, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=275, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=287, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=287, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=310, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=310, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=315, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=315, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=317, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=364, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=364, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=400, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=410, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=474, label="dedup", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=474, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1170, label="blackscholes", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1170, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=423, label="ferret", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=423, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1380, label="freqmine", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1380, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=16, label="canneal", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=16, linetype="dashed", color = "darkgreen", size=0.3) +
	

	
	coord_cartesian(ylim = c(0, 4), xlim = c(-45, 1700), clip = "off") + xlim(-45, 1700) +
	scale_y_continuous(
		sec.axis = sec_axis(~.*25000,
			name="QPS",
			labels=function(y) paste0(y/1000, "k"))
		) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("1B\n\n") +
	labs(x = "Time [s]", y = "#cores memc") +
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
	    axis.title.y = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    axis.title.y.right = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12,
	  		angle = 90),
	    plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p4_5_1b.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))



#2A
p<-ggplot(data=p4_2, aes(x = time)) + 
	geom_step(aes(y = QPS/25), colour="darkolivegreen3") + 
	geom_step(aes(y = p95), colour="dodgerblue3") + 
	annotate("text", x=-35, label="p95", y=150, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-35, label="QPS", y=400, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=-10, label="p95", y=150, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=-10, label="QPS", y=400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	geom_vline(xintercept=35, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=68, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=68, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=79, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=83, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=84, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=88, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=88, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=89, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=89, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=93, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=95, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=96, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=98, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=123, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=123, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=145, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=145, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=211, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=211, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=222, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=223, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=227, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=228, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=230, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=230, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=231, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=255, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=255, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=266, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=266, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=271, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=272, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=276, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=288, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=288, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=299, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=314, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=314, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=315, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=315, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=365, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=365, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=431, label="unpause fft", y=-200, angle=60, size=2.2 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=431, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	geom_vline(xintercept=450, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1161, label="blackscholes", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1161, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=440, label="ferret & dedup", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=442, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1370, label="freqmine", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1370, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=26, label="canneal & fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=26, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4000), xlim = c(-35, 1700), clip = "off") + xlim(-35, 1700) + 
	
	#geom_hline(yintercept=2000, linetype="dashed", 
    #            color = "red", size=0.5) + 
	scale_y_continuous(
		labels=function(x)x/1000,

		sec.axis = sec_axis(~.*25,
			name = "QPS",
			labels=function(y) paste0(y/1000, "k")),
		) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("2A\n\n") +
	labs(x = "Time [s]", y = "95th percentile latency [ms]") +
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
	    axis.title.y = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    axis.title.y.right = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12,
	  		angle = 90),
	  	plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p4_5_2a.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

#2B
p<-ggplot(data=p4_2, aes(x = time)) + 
	geom_step(aes(y = QPS/25000), colour="darkolivegreen3") + 
	geom_step(data = p4_2_cores, aes(x = time, y = nr_cores), colour="dodgerblue3") + 
	annotate("text", x=-45, label="#cores", y=1.5, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-40, label="QPS", y=0.2, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	geom_vline(xintercept=35, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=68, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=68, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=79, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=83, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=84, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=88, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=88, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=89, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=89, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=93, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=95, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=96, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=98, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=123, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=123, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=145, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=145, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=211, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=211, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=222, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=223, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=227, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=228, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=230, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=230, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=231, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=255, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=255, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=266, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=266, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=271, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=272, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=276, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=288, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=288, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=299, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=314, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=314, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=315, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=315, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=365, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=365, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=431, label="unpause fft", y=-.200, angle=60, size=2.2 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=431, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	geom_vline(xintercept=450, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1161, label="blackscholes", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1161, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=440, label="ferret & dedup", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=442, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1370, label="freqmine", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1370, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=26, label="canneal & fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=26, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4), xlim = c(-45, 1700), clip = "off") + xlim(-45, 1700) +
	scale_y_continuous(
		sec.axis = sec_axis(~.*25000,
			name="QPS",
			labels=function(y) paste0(y/1000, "k"))
		) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("2B\n\n") +
	labs(x = "Time [s]", y = "#cores memc") +
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
	    axis.title.y = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    axis.title.y.right = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12,
	  		angle = 90),
	    plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p4_5_2b.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))



#3A
p<-ggplot(data=p4_3, aes(x = time)) + 
	geom_step(aes(y = QPS/25), colour="darkolivegreen3") + 
	geom_step(aes(y = p95), colour="dodgerblue3") + 
	annotate("text", x=-35, label="p95", y=150, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-35, label="QPS", y=400, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=-10, label="p95", y=150, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=-10, label="QPS", y=400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	annotate("text", vjust=0.5, hjust=0, x=38, label="fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=34, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=67, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=67, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=80, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=80, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=94, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=94, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=99, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=99, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=122, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=122, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=144, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=144, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=209, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=209, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=253, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=253, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=265, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=265, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=275, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=275, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=286, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=297, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=297, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=305, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=305, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=307, linetype="dashed", color = "darkgoldenrod3", size=0.3) +	
#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=361, label="dedup", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=361, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1103, label="blackscholes", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1103, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=415, label="ferret", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=415, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1312, label="freqmine", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1312, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=15, label="canneal", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=19, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4000), xlim = c(-35, 1700), clip = "off") + xlim(-35, 1700) +
	
	#geom_hline(yintercept=2000, linetype="dashed", 
    #            color = "red", size=0.5) + 
	scale_y_continuous(
		labels=function(x)x/1000,

		sec.axis = sec_axis(~.*25,
			name = "QPS",
			labels=function(y) paste0(y/1000, "k")),
		) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("3A\n\n") +
	labs(x = "Time [s]", y = "95th percentile latency [ms]") +
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
	    axis.title.y = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    axis.title.y.right = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12,
	  		angle = 90),
	  	plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p4_5_3a.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

#3B
p<-ggplot(data=p4_3, aes(x = time)) + 
	geom_step(aes(y = QPS/25000), colour="darkolivegreen3") + 
	geom_step(data = p4_3_cores, aes(x = time, y = nr_cores), colour="dodgerblue3") + 
	annotate("text", x=-45, label="#cores", y=1.5, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-40, label="QPS", y=0.2, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +

#fft
	annotate("text", vjust=0.5, hjust=0, x=38, label="fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=34, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=67, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=67, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=80, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=80, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=94, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=94, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=99, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=99, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=122, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=122, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=144, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=144, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=209, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=209, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=253, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=253, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=265, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=265, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=275, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=275, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=286, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=297, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=297, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=305, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=305, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=307, linetype="dashed", color = "darkgoldenrod3", size=0.3) +	
#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=361, label="dedup", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=361, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1103, label="blackscholes", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1103, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=415, label="ferret", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=415, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1312, label="freqmine", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1312, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=15, label="canneal", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=19, linetype="dashed", color = "darkgreen", size=0.3) +
	
	
	coord_cartesian(ylim = c(0, 4), xlim = c(-45, 1700), clip = "off") + xlim(-45, 1700) +
	scale_y_continuous(
		sec.axis = sec_axis(~.*25000,
			name="QPS",
			labels=function(y) paste0(y/1000, "k"))
		) + 
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("3B\n\n") +
	labs(x = "Time [s]", y = "#cores memc") +
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
	    axis.title.y = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12),
	    axis.title.y.right = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12,
	  		angle = 90),
	    plot.title = element_text(family = "Helvetica",
	  		face = "bold",
	  		colour = "black",
	  		size = 12))

ggsave(filename="./p4_5_3b.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))