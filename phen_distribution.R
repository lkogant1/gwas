#DISTRIBUTION OF A PHENOTYPE
library(ggplot2)
phen <- read.csv(file="PHEN_FILE",header=T)

a1 <- ggplot(phen,aes(x=PHENOTYPE))+geom_bar() + geom_text(stat='bin',binwidth=1,aes(label=..count..),vjust=-1)+scale_y_continuous(name="Frequency",limits=c(0,3100))+scale_x_continuous(name="Counts",breaks=seq(0,21,1))+ggtitle("EA - Distribution of PHENOTYPE")+theme(plot.title = element_text(hjust = 0.5))
#
sum(phen[,5] == 0)
sum(phen[,5] > 0)
x1 <- c(0,">=1")
y1 <- c((sum(phen[,5] == 0)),(sum(phen[,5] > 0)))
df1 <- data.frame(x1,y1)
df1
#
a2 <- ggplot(df1,aes(x=x1,y=y1))+geom_bar(stat="identity")+scale_y_continuous(name="Frequency",limits=c(0,4500))+xlab("Counts")+ggtitle("EA - Distribution of PHENOTYPE")+theme(plot.title = element_text(hjust = 0.5))+geom_text(aes(label=y1,y=y1),vjust=-1)
#
library(gridExtra)
pdf("ea_PHEN_dist.pdf")
grid.arrange(a1,a2, ncol = 1, nrow = 2)
dev.off()

#---------------------------------