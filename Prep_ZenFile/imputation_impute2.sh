#imputation with impute2
#submit jobs for each chromosome
#!/bin/bash

echo "USAGE: ./imputation_impute2.sh <chr> <start Mb for that chromosome> <end Mb for that chromosome>"
for i in $(seq $2 5 $3)
do
j=$((i+5))
g="e6"
h="_combined_b37.txt"
k="_impute.hap"
l="_impute.legend"
m="phased"
n="_jg"
cd /PATH/Shapeit_DataSetName/chr$1$n/IMPUTE2/ 
if [ -f runimpute2_chr$1.part$i.$j.sh ]
then
rm runimpute2_chr$1.part$i.$j.sh
fi

touch runimpute2_chr$1.part$i.$j.sh
echo "#!/bin/bash" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -J RunImpute" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -P account_name" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -q priority" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -n 1" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -W time" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -R \"rusage[mem=20000]\"" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -o %J.stdout" >> runimpute2_chr$1.part$i.$j.sh
echo "#BSUB -eo %J.stderr" >> runimpute2_chr$1.part$i.$j.sh
echo "cd /PATH/Shapeit_DataSetName/chr$1$n/IMPUTE2/" >> runimpute2_chr$1.part$i.$j.sh
echo "touch startstop_chr$1.part$i.$j.txt" >> runimpute2_chr$1.part$i.$j.sh
echo "date >> startstop_chr$1.part$i.$j.txt" >> runimpute2_chr$1.part$i.$j.sh
#echo "module load impute2
echo "/PATH/impute_v2.3.2_x86_64_static/impute2 -use_prephased_g -known_haps_g /PATH/Shapeit_DataSetName/chr$1$n/chr$1$n.$m.haps -m /PATH/Public_Data/1000GP_Phase3/genetic_map_chr$1$h -h /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr$1.hap -l /PATH/Public_Data/1000GP_Phase3/1000GP_Phase3_chr$1.legend -buffer 1000 -Ne 20000 -int $i$g $j$g -k_hap 500 -o /PATH/Shapeit_DataSetName/chr$1$n/IMPUTE2/chr$1.$i.$j.$m.impute2" -o_gz >> runimpute2_chr$1.part$i.$j.sh


echo "date >> startstop_chr$1.part$i.$j.txt" >> runimpute2_chr$1.part$i.$j.sh
echo "rm runimpute2_chr$1.part$i.$j.sh" >> runimpute2_chr$1.part$i.$j.sh
chmod +x runimpute2_chr$1.part$i.$j.sh
bsub < runimpute2_chr$1.part$i.$j.sh
done
