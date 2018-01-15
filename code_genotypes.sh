#genotypes are coded as a single allele dosage number
#!/bin/csh
#BSUB -J RecodeA 
#BSUB -P accountname
#BSUB -q proirity level
#BSUB -n 1
#BSUB -R "rusage[mem=40000]"
#BSUB -W time
#BSUB -m filesystem 
#BSUB -o %J.stdout
#BSUB -eo %J.stderr

set history=0 

cd /PATH/RecodeA/Split_Files/

module load plink2/b3q
foreach file (`ls /PATH/Split_Files/*_split_*`)

plink --memory 35000 --bfile /PATH/PLINK_FILENAME --extract ${file} --recodeA --out ${file}_recodeA

cut -d ' ' -f2,7- ${file}_recodeA.raw | head -1 |sed "s/ /,/g" | sed "s/IID/id/" > ${file}_header.txt
cut -d ' ' -f2,7- ${file}_recodeA.raw | egrep -v IID | sort -k 1,1 | sed "s/ /,/g" | sed "s/NA//g" | sed "s/IID/id/" > ${file}_tail.txt

cat ${file}_header.txt ${file}_tail.txt > ${file}_recodeA.txt

rm ./${file}_recodeA.raw ./${file}_header.txt ./${file}_tail.txt

end

