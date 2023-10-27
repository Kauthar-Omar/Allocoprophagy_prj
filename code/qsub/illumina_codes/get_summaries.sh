#!/bin/bash
#$ -cwd 
#$ -N broman_sample_summaries
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
# -l virtual_free=20G
#$ -t 1-20

CHR=${SGE_TASK_ID}
OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta"
SORT_DIR="$OUT_DIR/Rnor_6.0_alignments/*"

PLOT_DIR="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/plot"

CODE_DIR="/users/abaud/htonnele/PRJs/P50/mixup/code"

# Rscript for sample summaries - per chr - {single,pair}_result 
# same as Broman except for all what concern names of files, samples, chr and options - directories
RCODE_2="$CODE_DIR/R/get_sample_summaries_v4.R"

GENO_DIR="/users/abaud/htonnele/PRJs/P50/mixup/output/genotype"

COUNT_ALL="$OUT_DIR/Rnor_6.0_alignments/readcount" #NB: WTO final /
SS="$OUT_DIR/sample_summaries/" #NB: NEED final /
mkdir -p $SS

conda activate R

echo "Getting sample_summaries for CHR $CHR"
#for CHR in {1..20..1}; do
Rscript --vanilla $RCODE_2 $CHR $COUNT_ALL $SS
#done

#qsub broman_sample_summaries.sh
