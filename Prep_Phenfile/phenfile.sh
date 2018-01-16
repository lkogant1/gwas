#----------------------------------------------------------------------------------------------
#PHENOTYPE FILE PREP:
#for R - cases anad controls are coded differently
awk '{gsub(/1/,"0",$5)}1' phen_file | awk '{gsub(/1/,"0",$6)}1' | awk '{gsub(/1/,"0",$7)}1' | awk '{gsub(/1/,"0",$8)}1' | awk '{gsub(/1/,"0",$9)}1' | awk '{gsub(/1/,"0",$10)}1' | awk '{gsub(/1/,"0",$11)}1' | awk '{gsub(/1/,"0",$12)}1'| awk '{gsub(/2/,"1",$5)}1' |  awk '{gsub(/2/,"1",$6)}1'|  awk '{gsub(/2/,"1",$7)}1' |  awk '{gsub(/2/,"1",$8)}1' | awk '{gsub(/2/,"1",$9)}1' | awk '{gsub(/2/,"1",$10)}1' | awk '{gsub(/2/,"1",$11)}1' | awk '{gsub(/2/,"1",$12)}1' > phen_file2
#----------------------------------------------------------------------------------------------
#ADD COVARIATES - SEX, PC1,PC2,PC3
cp /DATA/ALL_PHENFILE.csv .
cut -d',' -f1,6,11,12,13 ALL_PHENFILE.csv | sort -t, -k1,1 > covariates
#SORT
sort -t, -k1,1 SPECIFIC_PHENFILE.csv > SPECIFIC_PHENFILE.csv
#JOIN phenfile with covariates file
join -t, -1 1 -2 1 SPECIFIC_PHENFILE.csv covariates > SPECIFIC_PHENFILE_B.csv
tail -1 SPECIFIC_PHENFILE_B > header2
cat header2 SPECIFIC_PHENFILE_B.csv > SPECIFIC_PHENFILE_C.csv
head -n-1 SPECIFIC_PHENFILE_C.csv > SPECIFIC_PHENFILE_D.csv
cp SPECIFIC_PHENFILE_D.csv PHEN_FILE_FINAL.csv
#----------------------------------------------------------------------------------------------