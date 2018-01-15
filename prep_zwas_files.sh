#!/bin/bash
#1) REMOVE DUPLICATE AND ATCG SNPS
#2) PRE-IMPUTATION FILTERING
#3) PREPARATION FOR SHAPEIT and RUN SHAPEIT 
#4) IMPUTATION
#5) POST-IMPUTATION CLEANING

path: /PATH/Data/Imputation
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#1) REMOVE DUPLICATE AND ATCG SNPS
#1a - remove duplicate snps - list-duplicate-vars
plink --memory 30000 --bfile data --list-duplicate-vars --out first_duplicate_snps_list
~/remove_extra_spaces.sh first_duplicate_snps_list.dupvar > first_duplicate_snps_list.dupvar2
cut -d ' ' -f5 first_duplicate_snps_list.dupvar2 > first_duplicate_snps_list.dupvar3
#manually added ids for positions that have more than two snps at a position
plink --bfile data --exclude first_duplicate_snps_list.dupvar3 --make-bed --out datab

#1b - remove duplicate snps - unix command line
~/remove_extra_spaces.sh datab.bim | cut -d ' ' -f1,4 | sed 's/ /_/g' | sort | uniq -c | ~/remove_extra_spaces.sh | egrep -v '^1' > second_duplicate_snps_list
cut -d ' ' -f2 second_duplicate_snps_list | cut -d ' ' -f2 | sed 's/_/ /g' > second_duplicate_snps_list2
~/remove_extra_spaces.sh datab.bim | grep '^11' | grep -w '640350' > second_duplicate_snps_list3
~/remove_extra_spaces.sh datab.bim |  grep '^11' | grep -w '640351' >> second_duplicate_snps_list3
~/remove_extra_spaces.sh datab.bim | grep '^11' | grep -w '640370' >> second_duplicate_snps_list3
~/remove_extra_spaces.sh datab.bim | grep '^15' | grep -w '73591001' >> second_duplicate_snps_list3
~/remove_extra_spaces.sh datab.bim | grep '^19' | grep -w '41354169' >> second_duplicate_snps_list3
~/remove_extra_spaces.sh datab.bim | grep '^19' | grep -w '41354629' >> second_duplicate_snps_list3

cp second_duplicate_snps_list3 second_duplicate_snps_list4
emacs -nw second_duplicate_snps_list4 #removed duplicate snps at the same position
cut -d ' ' -f2 second_duplicate_snps_list4 > second_duplicate_snps_list5
plink --bfile datab --exclude second_duplicate_snps_list5 --make-bed --out datac

#1c check for duplicate rsids
~/remove_extra_spaces.sh datab.bim | cut -d ' ' -f2 | sort | uniq -c | ~/remove_extra_spaces.sh | egrep -v '^1' #none

#1d Remove AT,TA,CG,GC allelic snps
~/remove_extra_spaces.sh datac.bim | grep 'A\sT\|T\sA\|C\sG\|G\sC' > atcg_snps.txt 
~/remove_extra_spaces.sh atcg_snps.txt | cut -d ' ' -f2 > atcg_snps2.txt
plink --bfile datac --exclude atcg_snps2.txt --make-bed --out datad

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#2) PRE-IMPUTATION FILTERING
#2a genotyping rate 98%
plink --bfile datad --geno 0.02 --make-bed --out datae
#variants removed due to missing genotype data

#NOT DOING THIS PART - DON'T WANT TO REMOVE PEOPLE
#2b individual missing rate - 98%
plink --bfile datae --mind 0.02 --make-bed --out dataf
33 people removed due to missing genotype data

#NOT DOING THIS PART - BECOZ LEAH ALREADY LOOKED INTO THIS ISSUE
#2c check sex
plink --bfile dataf --check-sex --out sex_check

#Error: --check-sex/--impute-sex requires at least one polymorphic X chromosome
locus.
Warning: Nonmissing nonmale Y chromosome genotype(s) present.
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#3) PREPARATION FOR SHAPEIT and RUN SHAPEIT 
#3a) shapeit-check 
#chromosome# folders
mkdir Shapeit_Check
for W in `seq 1 22`;
do
plink --bfile datae --chr $W --make-bed --out /PATH/Data/Imputation/Shapeit_Check/chr$W\_shapeit_check
done    
        
#-------------------------------
module load shapeit/v2r790
for number in `seq 1 22`;
do 
shapeit -check -B /PATH/Data/Imputation/Shapeit_Check/chr{number}_shapeit_check --input-ref /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr{number}.hap /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr{number}.legend /PATH/Public_Data/1000GP_Phase3/genetic_map_chr{number}_combined_b37.txt --output-log chr{number}_shapeit_check_align1
done

#eg:
#shapeit -check -B /PATH/Data/Imputation/Shapeit_Check/chr1_shapeit_check --input-ref /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr1.hap /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr1.legend /PATH/Public_Data/1000GP_Phase3/genetic_map_chr1_combined_b37.txt --output-log chr1_shapeit_check_align1
#shapeit -check -B /PATH/Data/Imputation/Shapeit_Check/chr2_shapeit_check --input-ref /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr2.hap /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr2.legend /PATH/Public_Data/1000GP_Phase3/genetic_map_chr2_combined_b37.txt --output-log chr2_shapeit_check_align1

#-------------------------------
for file in /PATH/;
do 
~/remove_extra_spaces.sh ${file} | grep Strand | cut -d ' ' -f4 | sort | uniq > ${file}_strand_snp_list
done

#eg:
# ~/remove_extra_spaces.sh chr1_shapeit_check_align1.snp.strand | grep Strand | cut -d ' ' -f4 | sort | uniq > chr1_strand_snp_list
# ~/remove_extra_spaces.sh chr2_shapeit_check_align1.snp.strand | grep Strand | cut -d ' ' -f4 | sort | uniq > chr2_strand_snp_list
#-------------------------------
#flip snps
for number in `seq 1 22`;
do 
plink --bfile /PATH/Data/Imputation/Shapeit_Check/chr{number}_shapeit_check --flip chr{number}_strand_snp_list --make-bed --out chr{number}_DataSetName
done

#-------------------------------
module load shapeit/v2r790
for number in `seq 1 22`;
do 
shapeit -check -B /PATH/Data/Imputation/Shapeit_Check/chr{number}_DataSetName --input-ref /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr{number}.hap /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr{number}.legend /PATH/Public_Data/1000GP_Phase3/genetic_map_chr{number}_combined_b37.txt --output-log chr{number}_shapeit_check_align2
done

#-------------------------------
mkdir ByChromosome_DataSetName
mv chr*_DataSetName ../ByChromosome_DataSetName
mv chr*_shapeit_check_align2 ../ByChromosome_DataSetName

#create a folder for each chromosome
mkdir DataSetName
cp phasing_shapeit_a phasing_shapeit_b /PATH/Data/Imputation/DataSetName

#junk - chr1, chr2..chr22
csh
foreach line(`cat junk`)
mkdir /PATH/Data/Imputation/DataSetName/$line
end 

#create symbolic link
csh
foreach file (`ls /PATH/Data/Imputation/DataSetName/`)
ln -s /PATH/Data/Imputation/DataSetName/phasing_shapeit_a /PATH/Data/Imputation/DataSetName/${file}/
end

#changed phasing_shapeit_a and phasing_shapeit_b script before submitting
#submit jobs to server
./phasing_shapeit_b

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#4) IMPUTATION
cp imputation_impute2.sh /PATH/Data/Imputation/DataSetName
head -2 *.snp.me #get coordinates and submit the job
tail -1 *.snp.me

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#5) POST-IMPUTATION CLEANING
merge all chromosomes in parse_jg folder
emacs -nw merge_list_DataSetName

#format chr2_DataSetName_bg.bed chr2_DataSetName_bg.bim chr2_DataSetName_bg.fam
plink --bfile chr1_DataSetName_bg --merge-list merge_list_DataSetName --make-bed --out DataSetName_imputed_12012015
plink --bfile chr1_DataSetName_clean --merge-list merge_list_DataSetName --make-bed --out DataSetName_imputed_cleaned
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
