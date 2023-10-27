#This qsub script runs PLINK to create .bed, .bim and .fam files from .vcf, keeping reference alleles

#!/bin/bash
#$ -cwd
#$ -N plink
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -m abe
#$ -M kauthar.omar@crg.eu
#$ -l virtual_free=10G
#$ -q short-sl7
#$ -t 1-20

#Activate the multiqc environment
conda activate plink

#Run PLINK
OUT="/users/abaud/komar/P50/allocoprophagy/output/genotypes/"
IN="/users/abaud/komar/P50/allocoprophagy/data/genotypes/"

mkdir -p $OUT

plink --vcf ${IN}baud_hs_rats_round10_1_n32.vcf.gz --chr ${SGE_TASK_ID} --keep-allele-order --real-ref-alleles --make-bed --out ${OUT}hs_rats_n32_${SGE_TASK_ID}
