#!/bin/bash
#BSUB -J jobname
#BSUB -P account name
#BSUB -q alloc
#BSUB -n #no of nodes
#BSUB -R span[hosts=1]   
#BSUB -W time in mins
#BSUB -R rusage[mem=6000] #memory
#BSUB -o %J.stdout
#BSUB -eo %J.stderr
#BSUB -m filesystem

history=0

path=/PATH/Public_Data/1000GP_Phase3
path2=/PATH/Data/dbGaP/PLINK_sets/ByChromosome/


current_path=`pwd`
chr_filename=`basename $current_path`
chr_number=`echo $chr_filename | sed 's/_.*//'`

map_file=$path/genetic_map_${chr_number}_combined_b37.txt

bed_file=$path2/${chr_filename}.bed
bim_file=$path2/${chr_filename}.bim
fam_file=$path2/${chr_filename}.fam
exclude_snp_file=$path2/${chr_filename}*align2
phased_hap=${chr_filename}.phased.haps
phased_sample=${chr_filename}.phased.sample
log=${chr_filename}.shapeitlog



module load shapeit/v2r790
shapeit --input-bed $bed_file $bim_file $fam_file --input-map $map_file --exclude-snp $exclude_snp_file --output-max $phased_hap $phased_sample --thread 2 --states 500 --effective-size 17469 >> & $log


#TESTING
# check paths before submitting 
# echo $variable_name