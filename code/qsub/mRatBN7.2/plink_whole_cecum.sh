#This qsub script runs PLINK to create .bed, .bim and .fam files from .vcf, keeping reference alleles

#!/bin/bash
#$ -cwd
#$ -N plink_cecum_whole
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
OUT="/users/abaud/komar/P50/allocoprophagy/output/genotypes/cecum_whole_genotypes/"
IN="/users/abaud/komar/P50/allocoprophagy/data/genotypes/"

mkdir -p $OUT

#renaming the genotype file to only have ratid i.e 001, 002 etc
zcat ${IN}baud_hs_rats_round10_1_n32.vcf.gz | sed 's/Amelie32_//g' | sed 's/SP[0-9]*AAE//g' | grep -vE '^\S+\s+\S+\s+\S+\s+\.|^\S+\s+\S+\s+\S+\s+\S+\s+\.' | gzip > ${IN}renamed_genotypes.vcf.gz

gen_file=${IN}renamed_genotypes.vcf.gz

plink --vcf $gen_file --keep-fam ${IN}samples.txt --chr ${SGE_TASK_ID} --keep-allele-order --real-ref-alleles --make-bed --out ${OUT}hs_rats_n14_chr${SGE_TASK_ID}

mkdir -p ${OUT}rdata/
