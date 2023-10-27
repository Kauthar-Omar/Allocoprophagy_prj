#!/bin/bash

#$ -cwd 
#$ -N get_snps_pos_genotypes
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID.err

## GETTING GENOTYPES FROM .VCF FILE AS: chr \t pos \t allele2 \t allele1
GENO="/users/abaud/komar/P50/allocoprophagy/data/genotypes/baud_hs_rats_round10_1_n32.vcf.gz"
OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/genotypes/genotype_positions"

ALL="$OUT_DIR/chrALL_pos_alleles.tsv"
zcat $GENO | grep -vE '^\S+\s+\S+\s+\S+\s+\.|^\S+\s+\S+\s+\S+\s+\S+\s+\.' | grep -v '#' | cut -f 1,2,4,5 | tr ' ' '\t' > $ALL

# Dividing per chromosome
for chr in {1..20}; do 
    awk -F '\t' -v chr="$chr" '$1==chr' $ALL > $OUT_DIR/chr${chr}_pos_alleles.tsv; 
done

##GETTING ONLY CHROMOSOME AND POSITION

for chr in {1..20}; do awk -v chr="$chr" '$1==chr{OFS="\t"; print $1, $2}' $ALL > $OUT_DIR/snp_chr${chr}.tsv; done

#qsub get_snps_pos_genotypes.sh
