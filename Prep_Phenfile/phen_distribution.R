#DISTRIBUTION OF A PHENOTYPE
#check wthether it is normal 
#if not - try log and sqrt transformations
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
pdf("PHEN_dist.pdf")
grid.arrange(a1,a2, ncol = 1, nrow = 2)
dev.off()

#---------------------------------
#------------------------------------------
#------------------------------------------
#we cannot do sqrt transformation because we have negative values - sqrt of negative values is undefined.
#the same applies for log transformation - we cannot log tranform externalizing phenotype data - log of negative values is undefined.
#log transformation:#Substantially positive skewness (with zero values)
#Logarithmic(Log 10)
#NEWX = LG10(X+C)
#C = a constant added to each score so that the smallest score is 1.
#C = 1 - min(x)

library(ggplot2)
library(scales)
seven <- read.csv(file="PHEN_2017version.csv",sep=",",header=T)
five <- read.csv(file="PHEN_2015version.csv",sep=",",header=T)
seven2 <- (seven[,3])
seven3 <- na.omit(seven2)
#REMOVE NAs - 226 of them
dim(as.data.frame(seven3))
seven4 <- as.data.frame(seven3)

#counts distribution WITH OUT TRANSFORMAITON
pdf("NAME.pdf")
ggplot(seven,aes(x=PHEN))+
geom_histogram(stat="bin",na.rm=TRUE,binwidth=0.2,fill="grey81",colour="black")+
geom_text(stat='bin',binwidth=0.2,aes(label=..count..),vjust=-1)+
scale_x_continuous(name="PHENOTYPE",breaks=seq(-1,4,0.2))+
scale_y_continuous(name="Frequency",limits=c(0,1100))+
ggtitle("Distribution of PHENOTYPE")+
theme(plot.title = element_text(hjust = 0.5))
dev.off()

#define function: counts
bar_count <- function(v1){
p = ggplot(data=data.frame(v1),aes(x=v1))+
geom_histogram(stat="bin",na.rm=TRUE,binwidth=0.2,fill="grey81",colour="black")+
geom_text(stat='bin',binwidth=0.2,aes(label=..count..),vjust=-1)+
scale_x_continuous(name="PHENOTYPE",breaks=seq(-1,4,0.2))+
scale_y_continuous(name="Frequency",limits=c(0,1100))+
ggtitle("Distribution of PHENOTYPE")+
theme(plot.title = element_text(hjust = 0.5))
p
}

#LOG AND SQRT TRANSFORMATION
pdf("PHENOTYPE_logtransform.pdf")
bar_count(log(seven[,1]+(1-min(seven4[,1]))))
dev.off()
pdf("PHENOTYPE_sqrttransform.pdf")
bar_count(sqrt(seven[,1]+(1-min(seven4[,1]))))
dev.off()

#----------------------------------------------------
#this is great: percentages on bars - y-axis- counts
#https://www.r-bloggers.com/bar-charts-with-percentage-labels-but-counts-on-the-y-axis/
#http://t-redactyl.io/blog/2016/01/creating-plots-in-r-using-ggplot2-part-4-stacked-bar-plots.html
#http://stackoverflow.com/questions/11766856/normalizing-y-axis-in-histograms-in-r-ggplot-to-proportion
#COUNT DISTRIBUTION
pdf("PHENOTYPE_per_plum.pdf")
ggplot(seven4,aes(x=seven3))+
geom_histogram((aes(y=(..count..))),fill="plum3",binwidth=0.3,na.rm=TRUE,colour="black")+
geom_text(aes(y = (..count..),label = ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="black",binwidth=0.3,vjust=-1,size=4.0)+
scale_x_continuous(name="PHENOTYPE",breaks=seq(-1,4,0.3))+
scale_y_continuous(name="Counts",limits=c(0,1100))+
ggtitle("Distribution of PHENOTYPE")+
theme(plot.title = element_text(hjust = 0.5))
dev.off()

#bar_per
#define function: percentages
bar_per <- function(v1){
q = ggplot(data=data.frame(v1),aes(x=v1))+
geom_histogram((aes(y=(..count..))),fill="grey81",binwidth=0.2,na.rm=TRUE,colour="black")+
geom_text(aes(y = (..count..),label = ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="black",binwidth=0.2,vjust=-1,size=2.5)+
scale_x_continuous(name="PHENOTYPE",breaks=seq(-1,4,0.2))+
scale_y_continuous(name="Counts",limits=c(0,1100))+
ggtitle("Distribution of PHENOTYPE")+
theme(plot.title = element_text(hjust = 0.5))
q
}
#LOG TRANSFORMED
z <- log(seven4[,1]+(1-min(seven4[,1])))
z <- as.data.frame(z)
pdf("PHENOTYPE_logtransform.pdf")
ggplot(z,aes(x=z))+
geom_histogram((aes(y=(..count..))),fill="pink2",binwidth=0.2,na.rm=TRUE,colour="black")+
geom_text(aes(y = (..count..),label = ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="black",binwidth=0.2,vjust=-1,size=5)+
scale_x_continuous(name="log transformed PHENOTYPE",breaks=seq(-1,4,0.2))+
scale_y_continuous(name="Counts",limits=c(0,900))+
ggtitle("Distribution of PHENOTYPE")+
theme(plot.title = element_text(hjust = 0.5))
dev.off()


#SQRT TRANSFORMED
y <- sqrt(seven4[,1]+(1-min(seven4[,1])))
y <- as.data.frame(y)
pdf("PHENOTYPE_sqrttransform.pdf")
ggplot(y,aes(x=y))+
geom_histogram((aes(y=(..count..))),fill="lightskyblue2",binwidth=0.2,na.rm=TRUE,colour="black")+
geom_text(aes(y = (..count..),label = ifelse((..count..)==0,"",scales::percent((..count..)/sum(..count..)))), stat="bin",colour="black",binwidth=0.2,vjust=-1,size=5)+
scale_x_continuous(name="sqrt transformed PHENOTYPE",breaks=seq(-1,4,0.2))+
scale_y_continuous(name="Counts",limits=c(0,1000))+
ggtitle("Distribution of PHENOTYPE")+
theme(plot.title = element_text(hjust = 0.5))
dev.off()


##----------------------------------------------------
# Displays bar heights as percents with percentages above bars - yaxis - percent
#http://stackoverflow.com/questions/29869862/ggplot2-how-to-add-percentage-or-count-labels-above-percentage-bar-plot
#
pdf("PHENOTYPE_per_per.pdf")
ggplot(seven4, aes(seven3))+
geom_histogram((aes(y=(..count..)/sum(..count..))),fill="grey81",binwidth=0.2,colour="black")+
geom_text(aes(y=(..count..)/sum(..count..),label =ifelse((..count..)==0,"", scales::percent((..count..)/sum(..count..)))), stat="bin",colour="black",binwidth=0.2,vjust=-1,size=2.8)+
scale_y_continuous(labels=scales::percent)+
ylab("Percent")+
xlab("PHENOTYPE")
dev.off()
#----------------------------------------------------
