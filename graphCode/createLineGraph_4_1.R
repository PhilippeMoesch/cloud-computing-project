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

t1c1<-read.csv(file="./t1c1.csv",header=TRUE,sep=",")
t1c2<-read.csv(file="./t1c2.csv",header=TRUE,sep=",")
t2c1<-read.csv(file="./t2c1.csv",header=TRUE,sep=",")
t2c2<-read.csv(file="./t2c2.csv",header=TRUE,sep=",")
cpu_t2c1<-read.csv(file="./cpu_t2c1.csv",header=TRUE,sep=",")
cpu_t2c2<-read.csv(file="./cpu_t2c2.csv",header=TRUE,sep=",")

t1c1 <- t1c1 %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
t1c2 <- t1c2 %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
t2c1 <- t2c1 %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))
t2c2 <- t2c2 %>% 
	group_by(target) %>% 
	summarise(
			std_p = sd(p95)/sqrt(3),
			std_q = sd(QPS)/sqrt(3),
			p95 = mean(p95),
			QPS = mean(QPS))

t1c1$Memc <- "T1_C1"
t1c2$Memc <- "T1_C2"
t2c1$Memc <- "T2_C1"
t2c2$Memc <- "T2_C2"
cpu_t2c1$run <- "1"
cpu_t2c2$run <- "2"

all<-rbind(t1c1,t1c2,t2c1,t2c2)

p<-ggplot(data=all, aes(x = QPS, y = p95, group=Memc, color=Memc)) + 
	geom_line(aes(linetype = Memc)) + 
	geom_point() +
	scale_y_continuous(labels=function(x)x/1000) +
	geom_errorbar(aes(ymin = p95 - std_p, ymax = p95 + std_p),  size = 0.3, width = 200, alpha = 1) +
	geom_errorbar(aes(xmin = QPS - std_q, xmax = QPS + std_q),  size = 0.3, width = 200, alpha = 1) +
	scale_colour_brewer(palette = "Dark2") +
	ggtitle("95th percentile latency\n[ms]") +
	coord_cartesian(ylim = c(0, 3500), xlim = c(0, 120000), clip = "off") +
	scale_x_continuous(
		labels=function(y) paste0(y/1000, "k")) +
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

ggsave(filename="./p4_1.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

print(cpu_t2c1$p95)
p<-ggplot(data=cpu_t2c1, aes(x = QPS)) + 
	geom_line(aes(y = p95), colour="darkgoldenrod3") + 
	geom_line(aes(y = cpu_utilization*35), colour="darkolivegreen3") + 
	geom_text(aes(x=20000, label="p95", y=950, hjust=0), colour="darkgoldenrod3", angle=0, size=4 ) +
	geom_text(aes(x=20000, label="cpu_util", y=2400, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
	annotate("text", x=105000, label="cpu_util", y=4200, hjust=1, angle=0, size=5 , family = "Helvetica", fontface = "bold", colour = "black",) +
	coord_cartesian(ylim = c(0, 3600), xlim = c(0, 100000), clip = "off") +
	scale_x_continuous(
		labels=function(y) paste0(y/1000, "k")) +
	scale_y_continuous(
		labels=function(x)x/1000,
		sec.axis = sec_axis(~./35,
		labels = function(b) { paste0(round(b, 0), "%")})
		) + 
	geom_hline(yintercept=2000, linetype="dashed", 
                color = "red", size=0.5) + 
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

ggsave(filename="./p4_2_1.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))

p<-ggplot(data=cpu_t2c2, aes(x = QPS)) + 
	geom_line(aes(y = p95), colour="darkgoldenrod3") + 
	geom_line(aes(y = cpu_utilization*10), colour="darkolivegreen3") + 
	geom_text(aes(x=37500, label="p95", y=700, hjust=0), colour="darkgoldenrod3", angle=0, size=4 ) +
	geom_text(aes(x=37500, label="cpu_util", y=1100, hjust=0), colour="darkolivegreen3", angle=0, size=4 ) +
	annotate("text", x=99100, label="cpu_util", y=2420, angle=0, size=5 , family = "Helvetica", fontface = "bold", colour = "black",) +
	coord_cartesian(ylim = c(0, 2050), clip = "off") +
	scale_x_continuous(
		labels=function(y) paste0(y/1000, "k")) +
	scale_y_continuous(
		labels=function(x)x/1000,
		sec.axis = sec_axis(~./10,
		labels = function(b) { paste0(round(b, 0), "%")})
		) + 
	geom_hline(yintercept=2000, linetype="dashed", 
                color = "red", size=0.5) + 
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


ggsave(filename="./p4_2_2.pdf", plot=p, dpi=300, width=20, height=10, units=("cm"))
