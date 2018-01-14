#EIGENSTRAT PCA ANALYSIS 
#!/bin/bash
mkdir Eigenstrat

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#LIFTOVER YRI
#chr23 is coded as chrX in UCSC, the chr24 is coded as chrY, and chr26 is coded as chrM.

##copy liftover software to current folder
cp liftOver /PATH/Public_Data/hapmap3_pop/Liftover_YRI
cp hg18ToHg19.over.chain /PATH/hapmap3_pop/Liftover_YRI

##PREP YRI plink files for liftover
#liftover file has chromosome number, start position, end position, and  SNP name.
~/correct_spaces ../hapmap3_r2_b36_fwd.YRI.qc.poly.map | cut -d ' ' -f1,2,4 | sed 's/^/chr/g' | awk '{print $1,$2,$3,$3}' | awk '{$4++; print$0}' | awk '{print $1,$3,$4,$2}' | sed 's/chr23/chrX/g' | sed 's/chr24/chrY/g' > prep_liftover_yri

#RUN LIFTOVER
./liftOver prep_liftover_yri hg18ToHg19.over.chain yri_liftover_hg19 yri_liftover_unmapped

##UPDATE plink files
egrep -v "#" yri_liftover_unmapped | ~/correct_spaces | cut -d ' ' -f4 > yri_drop_unmapped_snps
~/correct_spaces yri_liftover_hg19 | cut -d ' ' -f2,4 | awk '{print $2,$1}' > yri_map_update
module load plink2/b3q
plink --memory 30000 --file ../hapmap3_r2_b36_fwd.YRI.qc.poly --exclude yri_drop_unmapped_snps --update-map yri_map_update --make-bed --out Hapmap3_hg19_YRI_a
~/correct_spaces yri_liftover_hg19 | cut -d' ' -f4 > yri_keep_snps
plink --bfile Hapmap3_hg19_YRI_a --extract yri_keep_snps --make-bed --out Hapmap3_hg19_YRI_01122016


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#LIFTOVER CEU
##copy liftover software to current folder
cp /PATH/Public_Data/hapmap3_pop/Liftover_YRI/Prep_YRI_Liftover_Files/liftOver .
cp /PATH/Public_Data/hapmap3_pop/Liftover_YRI/Prep_YRI_Liftover_Files/hg18ToHg19.over.chain .

#PREP CEU plink files for liftover
#liftover file has chromosome number, start position, end position, and  SNP name.
~/correct_spaces ../hapmap3_r2_b36_fwd.CEU.qc.poly.map | cut -d ' ' -f1,2,4 | sed 's/^/chr/g' | awk '{print $1,$2,$3,$3}' | awk '{$4++; print$0}' | awk '{print $1,$3,$4,$2}' | sed 's/chr23/chrX/g' | sed 's/chr24/chrY/g' > prep_liftover_ceu

#RUN LIFTOVER
./liftOver prep_liftover_ceu hg18ToHg19.over.chain ceu_liftover_hg19 ceu_liftover_unmapped

##UPDATE plink files
egrep -v "#" ceu_liftover_unmapped | ~/correct_spaces | cut -d ' ' -f4 > ceu_drop_unmapped_snps
~/correct_spaces ceu_liftover_hg19 | cut -d' ' -f4 > ceu_keep_snps
~/correct_spaces ceu_liftover_hg19 | cut -d ' ' -f2,4 | awk '{print $2,$1}' > ceu_map_update

module load plink2/b3q
plink --memory 30000 --file ../hapmap3_r2_b36_fwd.CEU.qc.poly --exclude ceu_drop_unmapped_snps --update-map ceu_map_update --make-bed --out Hapmap3_hg19_CEU_a
plink --bfile  Hapmap3_hg19_CEU_a --extract ceu_keep_snps --make-bed --out Hapmap3_hg19_CEU_01122016

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#LIFTOVER JPT
##copy liftover software to current folder
cp /PATH/Public_Data/hapmap3_pop/Liftover_YRI/Prep_YRI_Liftover_Files/liftOver .
cp /PATH/Public_Data/hapmap3_pop/Liftover_YRI/Prep_YRI_Liftover_Files/hg18ToHg19.over.chain .

#PREP JPT plink files for liftover
#liftover file has chromosome number, start position, end position, and  SNP name.
~/correct_spaces ../hapmap3_r2_b36_fwd.JPT.qc.poly.map | cut -d ' ' -f1,2,4 | sed 's/^/chr/g' | awk '{print $1,$2,$3,$3}' | awk '{$4++; print$0}' | awk '{print $1,$3,$4,$2}' | sed 's/chr23/chrX/g' | sed 's/chr24/chrY/g' > prep_liftover_jpt

#RUN LIFTOVER
./liftOver prep_liftover_jpt hg18ToHg19.over.chain jpt_liftover_hg19 jpt_liftover_unmapped

##UPDATE plink files
egrep -v "#" jpt_liftover_unmapped | ~/correct_spaces | cut -d ' ' -f4 > jpt_drop_unmapped_snps
~/correct_spaces jpt_liftover_hg19 | cut -d' ' -f4 > jpt_keep_snps
~/correct_spaces jpt_liftover_hg19 | cut -d ' ' -f2,4 | awk '{print $2,$1}' > jpt_map_update

module load plink2/b3q
plink --memory 30000 --file ../hapmap3_r2_b36_fwd.JPT.qc.poly --exclude jpt_drop_unmapped_snps --update-map jpt_map_update --make-bed --out Hapmap3_hg19_JPT_a
plink --bfile  Hapmap3_hg19_JPT_a --extract jpt_keep_snps --make-bed --out Hapmap3_hg19_JPT_01122016

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#CREATE A MERGED GENOTYPE FILE WITH SAMPLES AND HAPMAP POPS - USING COMMONG SNPS
~/correct_spaces Hapmap3_hg19_YRI_01122016.bim > yri.bim
~/correct_spaces Hapmap3_hg19_JPT_01122016.bim > jpt.bim
~/correct_spaces  Hapmap3_hg19_CEU_01122016.bim > ceu.bim

#get common snps between hapmap pops
cut -d ' ' -f2 yri.bim | sort > yri_snps
cut -d ' ' -f2 ceu.bim | sort > ceu_snps
cut -d ' ' -f2 jpt.bim | sort > jpt_snps

comm -12 yri_snps jpt_snps | comm -12 - ceu_snps > common_snps
# -1 = suppress column 1 (lines unique to FILE1)
# -2 = suppress column 2 (lines unique to FILE2)
# -3 = suppress column 3 (lines that appear in both files)


#get common snps between yri, jpt, ceu and genotyped files
~/correct_spaces SAMPLE1_shapeit.bim | cut -d ' ' -f2 | sort > SAMPLE1_genotyped_snps
comm -12 common_snps_ceu_yri_jpt SAMPLE1_genotyped_snps > common_snps_ceu_yri_jpt_SAMPLE1

~/correct_spaces SAMPLE2_12292015_shapeit.bim | cut -d ' ' -f2 | sort > SAMPLE2_genotyped
comm -12 common_snps_ceu_yri_jpt_SAMPLE1genotyped SAMPLE2_genotyped > common_snps_ceu_yri_jpt_SAMPLE1genotyped_SAMPLE2genotyped


#create plink files of common snps
module load plink2/b3q

plink --memory 30000 --bfile /PATH/Public_Data/hapmap3_pop/Liftover_YRI/Hapmap3_hg19_YRI_01122016 --extract common_snps_ceu_yri_jpt_SAMPLE1genotyped_SAMPLE2genotyped --make-bed --out yri_common

plink --memory 30000 --bfile /PATH/Public_Data/hapmap3_pop/Liftover_CEU/Hapmap3_hg19_CEU_01122016 --extract common_snps_ceu_yri_jpt_SAMPLE1genotyped_SAMPLE2genotyped --make-bed --out ceu_common

plink --memory 30000 --bfile /PATH/Public_Data/hapmap3_pop/Liftover_JPT/Hapmap3_hg19_JPT_01122016 --extract common_snps_ceu_yri_jpt_SAMPLE1genotyped_SAMPLE2genotyped --make-bed --out jpt_common

plink --memory 30000 --bfile /PATH/Data/dbGaP/SAMPLE1_12292015_shapeit --extract common_snps_ceu_yri_jpt_SAMPLE1genotyped_SAMPLE2genotyped --make-bed --out SAMPLE1_common

plink --memory 30000 --bfile /PATH/Data/dbGaP/SAMPLE2_12292015_shapeit --extract common_snps_ceu_yri_jpt_SAMPLE1genotyped_SAMPLE2genotyped --make-bed --out SAMPLE2_common

#merge all files together
plink --bfile yri_common --merge-list allfiles.txt --make-bed --out ForEigenstart

emacs -nw allfiles.txt
ceu_common.bed ceu_common.bim ceu_common.fam
jpt_common.bed jpt_common.bim jpt_common.fam
SAMPLE1_common.bed SAMPLE1_common.bim SAMPLE1_common.fam
SAMPLE2_common.bed SAMPLE2_common.bim SAMPLE2_common.fam
#error: did not create merged files - gave *missnp file


#sol: flip snps
plink --memory 30000 --bfile ceu_common --flip *missnp --make-bed --out ceu_common_flip
plink --memory 30000 --bfile jpt_common --flip *missnp --make-bed --out jpt_common_flip
plink --memory 30000 --bfile yri_common --flip *missnp --make-bed --out yri_common_flip
plink --memory 30000 --bfile SAMPLE1_common --flip *missnp --make-bed --out SAMPLE1_common_flip
plink --memory 30000 --bfile SAMPLE2_common --flip *missnp --make-bed --out SAMPLE2_common_flip

#try again
plink --bfile yri_common_flip --merge-list allfiles_flip.txt --make-bed --out ForEigenstart

emacs -nw allfiles_flip.txt
ceu_common_flip.bed ceu_common_flip.bim ceu_common_flip.fam
jpt_common_flip.bed jpt_common_flip.bim jpt_common_flip.fam
SAMPLE1_common_flip.bed SAMPLE1_common_flip.bim SAMPLE1_common_flip.fam
SAMPLE2_common_flip.bed SAMPLE2_common_flip.bim SAMPLE2_common_flip.fam
#error: Nope, still left with 62552 variants


#merge hapmap pops first - create plink files
plink --memory 30000 --bfile ceu_common --merge-list all --make-bed --out yri_jpt_ceu

emacs -nw all
jpt_common.bed jpt_common.bim jpt_common.fam
yri_common.bed yri_common.bim yri_common.fam

#merge samples and then hapmap 
plink --memory 30000 --bfile SAMPLE1_common --bmerge SAMPLE2_common --make-bed --out SAMPLE1_SAMPLE2

plink --memory 30000 --bfile SAMPLE1_SAMPLE2 --bmerge yri_jpt_ceu --make-bed --out SAMPLE1_SAMPLE2_yri_jpt_ceu

plink --memory 30000 --bfile SAMPLE1_SAMPLE2 --flip SAMPLE1_SAMPLE2_yri_jpt_ceu-merge.missnp --make-bed --out SAMPLE1_SAMPLE2_flip

plink --memory 30000 --bfile SAMPLE1_SAMPLE2_flip --bmerge yri_jpt_ceu --make-bed --out SAMPLE1_SAMPLE2_yri_jpt_ceu

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##LD based snp pruning
plink --memory 30000 --bfile SAMPLE1_SAMPLE2_yri_jpt_ceu --indep 50 5 2
plink --memory 30000 --bfile SAMPLE1_SAMPLE2_yri_jpt_ceu --extract plink.prune.in --make-bed --out SAMPLE1_SAMPLE2_yri_jpt_ceu_pruned
1 ceu
2 jpt
3 yri
4 SAMPLE1
5 SAMPLE2

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#add phenotype
~/correct_spaces ceu_common.fam | cut -d ' ' -f1,2 | sed 's/$/ 1/g' > ceu_p
~/correct_spaces jpt_common.fam | cut -d ' ' -f1,2 | sed 's/$/ 2/g' > jpt_p
~/correct_spaces yri_common.fam | cut -d ' ' -f1,2 | sed 's/$/ 3/g' > yri_p
~/correct_spaces SAMPLE1_common.fam | cut -d ' ' -f1,2 | sed 's/$/ 4/g' > SAMPLE1_p
~/correct_spaces SAMPLE2_common.fam | cut -d ' ' -f1,2 | sed 's/$/ 5/g' > SAMPLE2_p
cat ceu_p jpt_p yri_p SAMPLE1_p SAMPLE2_p > phenotype_all

plink --bfile SAMPLE1_SAMPLE2_yri_jpt_ceu_pruned --pheno phenotype_all --make-bed --out SAMPLE1_SAMPLE2_yri_jpt_ceu_pruned_updated
#FILE IS READY TO RUN EIGENSTRAT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#RUN EIGENSTRAT
#copy software
cp hap_pops /PATH/
cp convertf.par /PATH/
cp run_eigenstrat /PATH/
#updated convertf.par
./run_eigenstrat

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

~/correct_spaces eigen.pca.evec | cut -d ' ' -f2,3,12 > pc1_pc2_pop.txt
egrep CEU pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.ceu
egrep YRI pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.yri
egrep JPT pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.jpt
egrep SAMPLE1 pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.SAMPLE1
egrep SAMPLE2 pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.SAMPLE2

emacs -nw amp
&

~/correct_spaces eigen.pca.evec | cut -d ' ' -f2,3,12 > pc1_pc2_pop.txt

egrep CEU pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.ceu
egrep YRI pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.yri
egrep JPT pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.jpt
egrep SAMPLE1 pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.SAMPLE1
egrep SAMPLE2 pc1_pc2_pop.txt | cut -d ' ' -f1,2 > pc1_pc2.SAMPLE2

cat pc1_pc2.ceu amp pc1_pc2.yri amp pc1_pc2.jpt amp pc1_pc2.SAMPLE1 amp pc1_pc2.SAMPLE2 > plot1.xmg


module load xmgrace
xmgrace plot1.xmg &

cd /PATH/Data/dbGaP/Combined_Imputed_Datasets/Eigenstrat/Plots

convert eigenplot.ps eigenplot.png

~/correct_spaces eigen.pca.evec | egrep 'SAMPLE1|SAMPLE2' | cut -d ' ' -f1-3 | sed 's/:/ /g' > pc1_pc2_components
#add header: famid iid pc1 pc2 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#exclude pc2 < 0.025
#keeping the samples that are clustered together.
awk '$4 > 0.025' pc1_pc2_components > pc1_pc2_extracted
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
