# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N fastqc_raw
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID.err
#$ -t 1-4

#Activate the qc environment
conda activate qc

#Run fastqc
OUT="/users/abaud/komar/P50/allocoprophagy/output/fastqc/"
INPUT=$(ls /users/abaud/komar/P50/allocoprophagy/data/*.fastq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
fastqc -o $OUT $INPUT