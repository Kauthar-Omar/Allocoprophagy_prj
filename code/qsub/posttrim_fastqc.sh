# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N fastqc_trimmed
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID_$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID_$TASK_ID.err
#$ -t 1-8

#Activate the qc environment
conda activate qc

#fastqc directories
OUT_p="/users/abaud/komar/P50/allocoprophagy/output/posttrim_qc/paired/"
OUT_unp="/users/abaud/komar/P50/allocoprophagy/output/posttrim_qc/unpaired/"
IN_PAIRED=$(ls /users/abaud/komar/P50/allocoprophagy/output/trimming/paired/*_paired.fq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
IN_unPAIRED=$(ls /users/abaud/komar/P50/allocoprophagy/output/trimming/unpaired/*_unpaired.fq.gz | sort -u | sed -n ${SGE_TASK_ID}p)

#Run fastqc on paired files
fastqc -o $OUT_p $IN_PAIRED

#Run fastqc on unpaired files
fastqc -o $OUT_unp $IN_unPAIRED