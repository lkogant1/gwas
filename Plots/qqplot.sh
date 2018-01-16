#------------------------------------------
#------------------------------------------
#QQPLOT maf>0.01
#WHERE: phen,snp,beta,se,pval
#grep out any empty results
#grep -v ",,,,,,," RESULTS_MERGED_r.csv > PHEN_qq1

#PREP FILE
#MAF > 0.01
awk -F, -v OFS="," '$3>0.01' RESULTS_MERGED_r.csv > qq001_1
#EXTRACT COLUMNS
cut -d',' -f4,2,10,11,15 qq001_1 > qq001_2
#CHANGE COLUMN NAME
sed 's/rsid/snp/' qq001_2 > qq001_3
#REARRANGE COLUMNS
awk -F, -v OFS="," '{print $2,$1,$3,$4,$5}' qq001_3 > qq001_4
#------------------------------------------
#PLOT
module load R
R
library(GWAF)
qq001_4 <- read.table("qq001_4",header=TRUE, sep=",")
qq(pvalue=qq001_4[,"pval"],outfile="QQ_PHENTYPE_NAME_001.png")
#---------------------------------------------------
#MAF>0.05 - PREP FILE
awk -F, -v OFS="," '$3>0.05' RESULTS_MERGED_r.csv > qq005_1
cut -d',' -f4,2,10,11,15 qq005_1 > qq005_2
sed 's/rsid/snp/' qq005_2 > qq005_3
awk -F, -v OFS="," '{print $2,$1,$3,$4,$5}' qq005_3 > qq005_4

#PLOT
module load R
R
library(GWAF)
qq005_4 <- read.table("qq005_4",header=TRUE, sep=",")
qq(pvalue=qq005_4[,"pval"],outfile="QQ_PHEN_NAME_005.png")

#RUN ON COMMAND LINE - INTERACTIVE MODE
#bsub -P acc_LOAD -q expressalloc -n 1 -W 2:00 -R "span[hosts=1]" -R "rusage[mem=12000]" -Ip /bin/csh
#------------------------------------------------------