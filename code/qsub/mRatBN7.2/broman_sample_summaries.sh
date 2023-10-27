#!/bin/bash
#$ -cwd 
#$ -N broman_sample_summaries
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -l virtual_free=10G
#$ -t 1-20

conda activate R

CHR=${SGE_TASK_ID}

OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2"

CODE_DIR="/users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/code"

# Rscript for generating snp_calls in rdata format using genio.
RCODE_1="$CODE_DIR/R/snp_calls.R"
PLINK_DIR="/users/abaud/komar/P50/allocoprophagy/output/genotypes/cecum_whole_genotypes/"
PREFIX="hs_rats_n14_chr"

Rscript --vanilla $RCODE_1 $PLINK_DIR $PREFIX

# Rscript for sample summaries - per chr - {single,pair}_result 
# same as Broman except for all what concern names of files, samples, chr and options - directories
RCODE_2="$CODE_DIR/R/get_sample_summaries_v4.R"


#Genotype directory in rdata generated from plink output
geno_rdata="/users/abaud/komar/P50/allocoprophagy/output/genotypes/cecum_whole_genotypes/rdata/" 
COUNT_ALL="$OUT_DIR/readcount/cecum_whole/round1" #NB: WTO final /
SS="$OUT_DIR/sample_summaries/cecum_whole/round1/" #NB: NEED final /
mkdir -p $SS

echo "Getting sample_summaries for CHR $CHR"
#for CHR in {1..20..1}; do
Rscript --vanilla $RCODE_2 $CHR $COUNT_ALL $geno_rdata $SS
#done

#qsub broman_sample_summaries.sh 
