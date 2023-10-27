# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N fastqc_raw_spleen
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID_$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID_$TASK_ID.err
#$ -pe smp 2
#$ -t 1-64

#Activate the qc environment
conda activate qc

#Run fastqc
OUT="/users/abaud/komar/P50/allocoprophagy/output/fastqc_spleen/"
INPUT=$(ls /users/abaud/data/primary/MAGs/BAUDAME_03/*.fastq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
fastqc -o $OUT -t $NSLOTS $INPUT
