# Plots Figure 1 (number of architecture-specific and architecture-independent builtins per project)

library(ggplot2)
library(reshape)
library(scales)
library(RColorBrewer)
library(dplyr)
library(ggh4x)
library(directlabels)

if(FALSE){
no<-read.csv(file="./P1_M0_no_interference.csv",header=TRUE,sep=",")
cpu<-read.csv(file="./P1_M0_CPU.csv",header=TRUE,sep=",")
l1i<-read.csv(file="./P1_M0_l1i.csv",header=TRUE,sep=",")
l2<-read.csv(file="./P1_M0_l2.csv",header=TRUE,sep=",")
l1d<-read.csv(file="./P1_M0_ld1.csv",header=TRUE,sep=",")
llc<-read.csv(file="./P1_M0_llc.csv",header=TRUE,sep=",")
membw<-read.csv(file="./P1_M0_membw.csv",header=TRUE,sep=",")


no<-read.csv(file="./5/no_interference.csv",header=TRUE,sep=",")
cpu<-read.csv(file="./5/CPU.csv",header=TRUE,sep=",")
l1i<-read.csv(file="./5/l1i.csv",header=TRUE,sep=",")
l2<-read.csv(file="./5/l2.csv",header=TRUE,sep=",")
l1d<-read.csv(file="./5/l1d.csv",header=TRUE,sep=",")
llc<-read.csv(file="./5/llc.csv",header=TRUE,sep=",")
membw<-read.csv(file="./5/membw.csv",header=TRUE,sep=",")

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

no<-read.csv(file="./3/no_interference.csv",header=TRUE,sep=",")
cpu<-read.csv(file="./3/CPU.csv",header=TRUE,sep=",")
l1i<-read.csv(file="./3/l1i.csv",header=TRUE,sep=",")
l2<-read.csv(file="./3/l2.csv",header=TRUE,sep=",")
l1d<-read.csv(file="./3/l1d.csv",header=TRUE,sep=",")
llc<-read.csv(file="./3/llc.csv",header=TRUE,sep=",")
membw<-read.csv(file="./3/membw.csv",header=TRUE,sep=",")

no <- no %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
cpu <- cpu %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
l1i <- l1i %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
l2 <- l2 %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
l1d <- l1d %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
llc <- llc %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
membw <- membw %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))

no$Interference <- "none"
cpu$Interference <- "cpu"
l1i$Interference <- "l1i"
l2$Interference <- "l2"
l1d$Interference <- "l1d"
llc$Interference <- "llc"
membw$Interference <- "membw"

all<-rbind(no,cpu,l1i,l2,l1d,llc,membw)
print(all)
p<-ggplot(data=all, aes(x = QPS, y = p95, group=Interference, color=Interference)) + 
	geom_line(aes(linetype = Interference)) + 
	geom_point() +
	scale_y_continuous(labels=function(x)x/1000) + 
	geom_hline(yintercept=2000, linetype="dashed", 
                color = "red", size=0.5) + 
	geom_errorbar(aes(ymin = p95 - std_p, ymax = p95 + std_p),  size = 0.3, width = 200, alpha = 1) +
	geom_errorbar(aes(xmin = QPS - std_q, xmax = QPS + std_q),  size = 0.3, width = 200, alpha = 1) +
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("95th percentile latency\n[ms]") +
	labs(x = "QPS", y = "") +
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

ggsave(filename="./M4_stderr_line.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))