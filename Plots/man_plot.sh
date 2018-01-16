#MANHATTAN PLOTS
#

#MANHATTAN PLOT for maf > 0.01
##WHERE: SNP CHR BP P
#should n't have NA - egrep -v NA or grep -v ",,,,,,," 
##ask for interactive mode -> to run on command line
bsub -P account_name -q prioritylevel -n 1 -W 2:00 -R "span[hosts=1]" -R rusage[mem=12000] -Ip /bin/bash

#-----------------------------------------------------------
#PREP FILE TO PLOT
#extract columns from results file
cut -d',' -f1,2,3,15 RESULTS_MERGED_r.csv > man_file
#MAF > 0.01
awk -F, -v OFS="," '$3>0.01' man_file > man001_1
#REARRANGE COLUMNS
awk -F, -v OFS="," '{print $2,$1,$4}' man001_1 > man001_2
#SUBSTITUTE _ WITH ',' IN A COLUMN
awk -F, -v OFS="," '{gsub(/_/,",",$2);print}' man001_2 > man001_3
#RENAME COLUMN NAMES
sed 's/rsid,CHR,BP,pval/SNP,CHR,BP,P/' man001_3 > man001_4
#COMMA TO SPACE 
sed 's/,/ /g' man001_4 >  man001_5
#-----------------------------------------------------------
#
module load R
R
library(qqman)
man001_5 = read.table(file="man001_5", header = TRUE)
png("Manhattan_maf001.png", width=2000, height=1000, pointsize=18)
manhattan(man001_5, main = "Manhattan plot of PHENOTYPE NAME at maf>0.01",ylim=c(0,10),col = c("blue4", "orange3"))
dev.off()

#-----------------------------------------------------------
#-----------------------------------------------------------
#-----------------------------------------------------------

#Int MANHATTAN PLOT for maf > 0.05
awk -F, -v OFS="," '$3>0.05' man_file > man005_1
awk -F, -v OFS="," '{print $2,$1,$4}' man005_1 > man005_2
awk -F, -v OFS="," '{gsub(/_/,",",$2);print}' man005_2 > man005_3
sed 's/rsid,CHR,BP,pval/SNP,CHR,BP,P/' man005_3 > man005_4
sed 's/,/ /g' man005_4 >  man005_5

#
#
module load R
R
library(qqman)
man005_5 = read.table(file="man005_5", header = TRUE)
png("Manhattan_maf005.png", width=2000, height=1000, pointsize=18)
manhattan(man005_5, main = "Manhattan plot of PHENOTYPE NAME  at maf>0.05",ylim=c(0,10),col = c("blue4", "orange3"))
dev.off()
#-----------------------------------------------------------
#-----------------------------------------------------------
#-----------------------------------------------------------

#Manhattan plot for all snps
awk -F, -v OFS="," '{print $2,$1,$4}' man_file > manall_1
awk -F, -v OFS="," '{gsub(/_/,",",$2);print}' manall_1 > manall_2
sed 's/rsid,CHR,BP,pval/SNP,CHR,BP,P/' manall_2 > manall_3
sed 's/,/ /g' manall_3 >  manall_4
#
#
module load R
R
library(qqman)
manall_4 = read.table(file="manall_4", header = TRUE)
png("Manhattan_allsnps.png", width=2000, height=1000, pointsize=18)
manhattan(man005_5, main = "Manhattan plot of PHENOTYPE NAME for all snps",ylim=c(0,10),col = c("blue4", "orange3"))
dev.off()

#-----------------------------------------------------------
#-----------------------------------------------------------
#-----------------------------------------------------------

#MP for genotyped snps - important to see how genotype snps pvalues compare wrt to all snps plot
cut -d',' -f1,2,15 mangytd_1 > mangytd_2
awk -F, -v OFS="," '{print $2,$1,$3}' mangytd_2 > mangytd_3
awk -F, -v OFS="," '{gsub(/_/,",",$2);print}' mangytd_3 > mangytd_4
sed 's/rsid,CHR,BP,pval/SNP,CHR,BP,P/' mangytd_4 > mangytd_5
sed 's/,/ /g' mangytd_5 > mangytd_6

module load R
R
library(qqman)
mangytd_6 = read.table(file="mangytd_6", header = TRUE)
png("Manhattan_mafgytd.png", width=2000, height=1000, pointsize=18)
manhattan(mangytd_6, main = "Manhattan plot of PHENOTYPE NAME for gtyped snps",ylim=c(0,10),col = c("blue4", "orange3"))
dev.off()

#------------------------------------------
#------------------------------------------