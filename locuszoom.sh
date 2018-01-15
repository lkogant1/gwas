#LOCUS ZOOM PLOTS#
#EXTRACT COLUMNS
cut -d',' -f2,15 MERGED_RESULTS_r.csv > locuszoom_a
#ADJUST SNP NAMES
awk 'BEGIN {OFS=FS=","} {gsub(/:[0-9]*:[A-Z]*:[A-Z]*/,"",$1);print}' locuszoom_a > locuszoom_b
#CHANGE COLUMN NAMES
sed 's/rsid,pval/MarkerName,P-value/' locuszoom_b > locuszoom_c
#TAB SEPARATED
sed 's/,/\t/g' locuszoom_c > locuszoom_d

cut -d',' -f1,2,15,16 MERGED_RESULTS_r.csv > xxx1
grep "9_" xxx1 | less
grep "20_" xxx1 | less
#---------------

sublime snps.txt
9_80292377,rs137920860 #Imputed
9_80332124,rs75142592 #Imputed
9_80469550,rs116833421 #Genotyped
20_17444187,rs150249813:17444187:G:A #Imputed
20_17361006,rs79109414 #Genotyped
#---------------
#lz_script
#!/bin/csh
foreach snp(`cat snps2.txt`)
locuszoom --metal locuszoom_d  --pop ETHNICITY --build hg19 --source 1000G_March2012 --refsnp $snp
end


#--------------------------------------------------
#--------------------------------------------------------
