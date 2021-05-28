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

p4_1<-read.csv(file="./p4_3_1.csv",header=TRUE,sep=",")
p4_2<-read.csv(file="./p4_3_2.csv",header=TRUE,sep=",")
p4_3<-read.csv(file="./p4_3_3.csv",header=TRUE,sep=",")
p4_1_cores<-read.csv(file="./p4_3_1_cores.csv",header=TRUE,sep=",")
p4_2_cores<-read.csv(file="./p4_3_2_cores.csv",header=TRUE,sep=",")
p4_3_cores<-read.csv(file="./p4_3_3_cores.csv",header=TRUE,sep=",")

#1A
p<-ggplot(data=p4_1, aes(x = time)) + 
	geom_step(aes(y = QPS/25), colour="darkolivegreen3") + 
	geom_step(aes(y = p95), colour="dodgerblue3") + 
	annotate("text", x=-35, label="p95", y=150, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-35, label="QPS", y=400, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=-10, label="p95", y=150, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=-10, label="QPS", y=400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	annotate("text", vjust=0.5, hjust=0, x=61, label="fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=61, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=72, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=72, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=111, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=111, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=131, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=131, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=192, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=192, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=201, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=201, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=211, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=211, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=223111, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=231, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=262, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=262, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=272, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=272, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=316, label="unpause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=316, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=314, label="dedup", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=314, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=958, label="blackscholes", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=958, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=344, label="ferret", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=344, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1143, label="freqmine", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1143, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=31, label="canneal", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=31, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4000), xlim = c(-35, 1450), clip = "off") + xlim(-35, 1450) +
	
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

ggsave(filename="./p4_3_1a.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

#1B
p<-ggplot(data=p4_1, aes(x = time)) + 
	geom_step(aes(y = QPS/25000), colour="darkolivegreen3") + 
	geom_step(data = p4_1_cores, aes(x = time, y = nr_cores), colour="dodgerblue3") + 
	annotate("text", x=-45, label="#cores", y=1.5, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-40, label="QPS", y=0.2, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +

#fft
	annotate("text", vjust=0.5, hjust=0, x=61, label="fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=61, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=72, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=72, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=111, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=111, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=131, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=131, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=192, label="unpause fft", y=4.250, angle=60, size=2.5, family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=192, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=201, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=201, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=211, label="unpause fft", y=4.250, angle=60, size=2.5, family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=211, linetype="dashed", color = "darkgoldenrod3", size=0.3) +	
	annotate("text", vjust=1, hjust=1, x=231, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=231, linetype="dashed", color = "red3", size=0.3) +	
	annotate("text", vjust=0.5, hjust=0, x=262, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=262, linetype="dashed", color = "darkgoldenrod3", size=0.3) +	
	annotate("text", vjust=1, hjust=1, x=272, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=272, linetype="dashed", color = "red3", size=0.3) +	
	annotate("text", vjust=1, hjust=1, x=316, label="unpause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=316, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=314, label="dedup", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=314, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=958, label="blackscholes", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=958, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=344, label="ferret", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=344, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1143, label="freqmine", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1143, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=31, label="canneal", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=31, linetype="dashed", color = "darkgreen", size=0.3) +
	

	
	coord_cartesian(ylim = c(0, 4), xlim = c(-45, 1450), clip = "off") + xlim(-45, 1450) +
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

ggsave(filename="./p4_3_1b.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))



#2A
p<-ggplot(data=p4_2, aes(x = time)) + 
	geom_step(aes(y = QPS/25), colour="darkolivegreen3") + 
	geom_step(aes(y = p95), colour="dodgerblue3") + 
	annotate("text", x=-35, label="p95", y=150, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-35, label="QPS", y=400, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=-10, label="p95", y=150, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=-10, label="QPS", y=400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	annotate("text", vjust=0.5, hjust=0, x=232, label="fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=232, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=261, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=261, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=272, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=272, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=346, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=346, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=375, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=376, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=376, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=380, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=380, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=381, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=393, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=432, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=435, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=435, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=437, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=439, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=440, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=440, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=441, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=521, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=532, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=532, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=552, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=552, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=562, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=572, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=574, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=575, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=576, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=577, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=580, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=581, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=581, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=582, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=587, label="dedup", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=587, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1026, label="blackscholes", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1026, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=322, label="ferret", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=322, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1214, label="freqmine", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1214, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=30, label="canneal", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=30, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4000), xlim = c(-35, 1500), clip = "off") + xlim(-35, 1500) +
	
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

ggsave(filename="./p4_3_2a.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

#2B
p<-ggplot(data=p4_2, aes(x = time)) + 
	geom_step(aes(y = QPS/25000), colour="darkolivegreen3") + 
	geom_step(data = p4_2_cores, aes(x = time, y = nr_cores), colour="dodgerblue3") + 
	annotate("text", x=-45, label="#cores", y=1.5, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-40, label="QPS", y=0.2, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +

#fft
	annotate("text", vjust=0.5, hjust=0, x=232, label="fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=232, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=261, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=261, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=272, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=272, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=346, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=346, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=375, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=376, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=376, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=380, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=380, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=381, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=393, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=432, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=435, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=435, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=437, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=439, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=440, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=440, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=441, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=521, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=532, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=532, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=552, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=552, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=562, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=572, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=574, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=575, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=576, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=577, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=580, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=581, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=581, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=582, linetype="dashed", color = "darkgoldenrod3", size=0.3) +

#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=587, label="dedup", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=587, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1026, label="blackscholes", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1026, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=322, label="ferret", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=322, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1214, label="freqmine", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1214, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=30, label="canneal", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=30, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4), xlim = c(-45, 1500), clip = "off") + xlim(-45, 1500) +
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

ggsave(filename="./p4_3_2b.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))



#3A
p<-ggplot(data=p4_3, aes(x = time)) + 
	geom_step(aes(y = QPS/25), colour="darkolivegreen3") + 
	geom_step(aes(y = p95), colour="dodgerblue3") + 

	annotate("text", x=-35, label="p95", y=150, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-35, label="QPS", y=400, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=-10, label="p95", y=150, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=-10, label="QPS", y=400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
#fft
	annotate("text", vjust=1, hjust=1, x=61, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=61, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=70, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=70, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=111, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=111, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=131, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=131, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=192, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=192, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=201, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=201, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=210, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=210, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=231, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=231, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=261, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=261, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=271, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=271, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=331, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=331, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=361, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=371, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=381, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=382, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=383, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=384, label="pause fft", y=-200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=384, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=386, label="unpause fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=386, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=387, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=389, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	
#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=420, label="dedup", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=420, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=991, label="blackscholes", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=991, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=362, label="ferret", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=362, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1183, label="freqmine", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1183, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=32, label="canneal & fft", y=4250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=32, linetype="dashed", color = "darkgreen", size=0.3) +
	
	coord_cartesian(ylim = c(0, 4000), xlim = c(-35, 1470), clip = "off") + xlim(-35, 1470) +
	
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

ggsave(filename="./p4_3_3a.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

#3B
p<-ggplot(data=p4_3, aes(x = time)) + 
	geom_step(aes(y = QPS/25000), colour="darkolivegreen3") + 
	geom_step(data = p4_3_cores, aes(x = time, y = nr_cores), colour="dodgerblue3") + 

	annotate("text", x=-45, label="#cores", y=1.5, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "dodgerblue3",) +
	annotate("text", x=-40, label="QPS", y=0.2, angle=0, size=4 , family = "Helvetica", fontface = "bold", colour = "darkolivegreen3",) +
	#geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="dodgerblue3", angle=0, size=4 ) +
	#geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +

#fft
	annotate("text", vjust=1, hjust=1, x=61, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=61, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=70, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=70, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=111, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=111, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=131, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=131, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=192, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=192, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=201, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=201, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=210, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=210, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=231, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=231, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=261, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=261, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=271, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=271, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=331, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=331, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=361, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=371, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=381, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=382, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=383, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	annotate("text", vjust=1, hjust=1, x=384, label="pause fft", y=-.200, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "red3",) +
	geom_vline(xintercept=384, linetype="dashed", color = "red3", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=386, label="unpause fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgoldenrod3",) +
	geom_vline(xintercept=386, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	geom_vline(xintercept=387, linetype="dashed", color = "red3", size=0.3) +
	geom_vline(xintercept=389, linetype="dashed", color = "darkgoldenrod3", size=0.3) +
	
#PARSEC jobs
	annotate("text", vjust=0.5, hjust=0, x=420, label="dedup", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=420, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=991, label="blackscholes", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=991, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=362, label="ferret", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=362, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=1183, label="freqmine", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=1183, linetype="dashed", color = "darkgreen", size=0.3) +
	annotate("text", vjust=0.5, hjust=0, x=32, label="canneal & fft", y=4.250, angle=60, size=2.5 , family = "Helvetica", fontface = "bold", colour = "darkgreen",) +
	geom_vline(xintercept=32, linetype="dashed", color = "darkgreen", size=0.3) +
	
	
	coord_cartesian(ylim = c(0, 4), xlim = c(-45, 1470), clip = "off") + xlim(-45, 1470) +
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

ggsave(filename="./p4_3_3b.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))