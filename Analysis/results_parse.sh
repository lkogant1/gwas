
#Merge results [5000 snps in each file]
awk 'NR == 1 || FNR > 1' results_*.csv > RESULTS_MERGED_a.csv
#-----------------------------------
#adjust the second column of snp names - R prints snp names in different format - hard to process
awk 'BEGIN {OFS=FS=","} {gsub(/\./,":",$2);print}' RESULTS_MERGED_a.csv > RESULTS_MERGED_b.csv
awk 'BEGIN {OFS=FS=","} {gsub(/\_/,",",$2);print}' RESULTS_MERGED_b.csv > RESULTS_MERGED_c.csv
sed 's/snp/snp,extra/g' RESULTS_MERGED_c.csv > RESULTS_MERGED_d.csv
sed 's/snp/rsid/' RESULTS_MERGED_d.csv > RESULTS_MERGED_e.csv
sort -t, -k2,2 RESULTS_MERGED_e.csv > RESULTS_MERGED_f.csv
#-----------------------------------
#ADD MAF_Founders #add maf from founders in family based gwas
cp /Data/FinalPedigree/MAF_FOUNDERS.txt .
#comma separated
sed 's/ /,/g' MAF_FOUNDERS.txt > aaa1
#extract columns
cut -d',' -f1,5,6 aaa1 > aaa2
#change header names
sed -i.bak 's/snp_id/rsid/g' aaa2
sed -i.bak 's/maf/maf_founders/g' aaa2
sort -t, -k1,1 aaa2 > aaa3
#MERGE MAF FROM FOUNDERS TO RESULTS FILE
join -t, -1 1 -2 2 aaa3 RESULTS_MERGED_f.csv > RESULTS_MERGED_g.csv
tail -1 RESULTS_MERGED_g.csv > header1
cat header1 RESULTS_MERGED_g.csv > RESULTS_MERGED_h.csv
head -n -1 RESULTS_MERGED_h.csv > RESULTS_MERGED_i.csv
#SORT RESULTS WITH OUT MOVING THE HEADER
(head -n+1 RESULTS_MERGED_i.csv && tail -n+2 RESULTS_MERGED_i.csv | sort -t, -g -k15,15) > RESULTS_MERGED_j.csv
#ADD Imp_or_Geno column - very useful when referring back
awk -F, -v OFS="," '{if($1 ~ /:/) print $0,"Imputed"; else print $0,"Genotyped";
}' RESULTS_MERGED_j.csv > RESULTS_MERGED_k.csv
sed 's/pval,Genotyped/pval,Imp_or_Geno/' RESULTS_MERGED_k.csv > RESULTS_MERGED_l.csv
#-----------------------------------
#ANNOTATING SNPS
cp /Data/variant_function .
sed 's/chr_pb/CHR_BP/' RESULTS_MERGED_l.csv > RESULTS_MERGED_m.csv
sort -t, -k3,3 RESULTS_MERGED_m.csv > RESULTS_MERGED_n.csv
join -t, -1 3 -2 1 RESULTS_MERGED_n.csv aafam_variant_function_2017_01_25_c > RESULTS_MERGED_o.csv
tail -1 RESULTS_MERGED_o.csv > header2
cat header2 RESULTS_MERGED_o.csv > RESULTS_MERGED_p.csv
head -n -1  RESULTS_MERGED_p.csv >  RESULTS_MERGED_q.csv
(head -n +1 RESULTS_MERGED_q.csv && tail -n +2 RESULTS_MERGED_q.csv | sort -t, -g -k15,15) > RESULTS_MERGED_r.csv
#-----------------------------------