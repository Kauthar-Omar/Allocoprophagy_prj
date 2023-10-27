#!/bin/bash
#$ -cwd 
#$ -N broman_sample_summaries_wc_f2
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -l virtual_free=10G
#$ -t 1-20


CHR=${SGE_TASK_ID}

OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2"

CODE_DIR="/users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/code"


# Rscript for sample summaries - per chr - {single,pair}_result 
# same as Broman except for all what concern names of files, samples, chr and options - directories
RCODE_2="$CODE_DIR/R/get_sample_summaries_v4.R"


#Genotype directory in rdata generated from plink output
COUNT_ALL="$OUT_DIR/readcount/cecal_leftover/flow_cell_2_corrected"
SS="$OUT_DIR/sample_summaries/cecal_leftover/flow_cell_2_corrected/"
mkdir -p $SS

echo "Getting sample_summaries for CHR $CHR"
#for CHR in {1..20..1}; do
Rscript --vanilla $RCODE_2 $CHR $COUNT_ALL $SS
#done

#qsub broman_sample_summaries_wc_fc2_corrected.sh 
