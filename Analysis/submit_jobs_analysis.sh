#!/bin/bash

for file in `ls /PATH/chr1/RecodeA/chr1_*split_*_recodeA.* | cut -d'/' -f{FILLIN} | sed 's/\.txt//g'`

do
cat <<EOF > ${file}.lsf
#!/bin/csh
#BSUB -J NAME
#BSUB -P account name
#BSUB -q proiity level
#BSUB -n 1 
#BSUB -R "rusage[mem=2000]" #memory
#BSUB -W 2:00
#BSUB -m filesystem
#BSUB -o %J.stdout
#BSUB -eo %J.stderr
#BSUB -L /bin/csh

set history=0

cd /PATH/

module load R

R --vanilla --args /PATH/chr1/RecodeA/${file}.txt PHEN_${file}.csv <R_analysis.R > PHEN_${file}.log    

EOF

bsub < ${file}.lsf

done
