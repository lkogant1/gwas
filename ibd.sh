#-------------------------------------------------------------------------------------
#IBD code:
awk '{print $1,$1}' AA_only_id > list.txt
plink --bfile PLINK_FILE --indep 50 5 2
plink --bfile PLINK_FILE --extract plink.prune.in --make-bed --out PLINK_FILE_pruned
plink --bfile PLINK_FILE_pruned --genome --min 0.05 

#
#check the relationship with pedigree file
plink --bfile PLINK_FILE_pruned --rel-check --genome --out FILENAME
egrep -v 'nan' FILENAME.genome | grep PO | less
egrep -v 'nan' FILENAME.genome | grep FS | less
egrep -v 'nan' FILENAME.genome | grep HS | less
egrep -v 'nan' FILENAME.genome | grep OT | less


##check pedigree errors
plink --bfile PLINK_FILE --me 1 1 -set-me-missing --make-bed --out PLINK_FILE

#-------------------------------------------------------------------------------------