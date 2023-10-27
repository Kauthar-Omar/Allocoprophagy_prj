# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N fastqc_raw
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID/$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID/$TASK_ID.err
#$ -pe smp 2
#$ -t 1-190

#Activate the qc environment
conda activate qc

#Run fastqc
OUT="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/fastqc/"

#creating output directories
mkdir -p $OUT

INPUT=$(ls /users/abaud/komar/P50/allocoprophagy/data/cecal/*.fastq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
fastqc -o $OUT -t $NSLOTS $INPUT
