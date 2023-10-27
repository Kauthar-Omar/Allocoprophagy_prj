# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N fastqc_trimmed_cutadapt
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID_$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID_$TASK_ID.err
#$ -t 1-4

#Activate the qc environment
conda activate qc

#fastqc directories
OUT="/users/abaud/komar/P50/allocoprophagy/output/posttrim_qc_cutadapt/"
IN=$(ls /users/abaud/komar/P50/allocoprophagy/output/trimmed_cutadapt/*_trimmed.fq.gz | sort -u | sed -n ${SGE_TASK_ID}p)


#Run fastqc on paired
fastqc -o $OUT $IN
