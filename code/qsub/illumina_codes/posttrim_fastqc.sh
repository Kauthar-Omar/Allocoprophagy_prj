# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N fastqc_trimmed
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID/$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID/$TASK_ID.err
#$ -m abe 
#$ -M kauthar.omar@crg.eu 
#$ -pe smp 2
#$ -t 1-380

#Activate the qc environment
conda activate qc

#fastqc directories
OUT_p="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/posttrim_qc/paired/"
OUT_unp="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/posttrim_qc/unpaired/"
IN_PAIRED=$(ls /users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/trimming/paired/*_paired.fq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
IN_unPAIRED=$(ls /users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/trimming/unpaired/*_unpaired.fq.gz | sort -u | sed -n ${SGE_TASK_ID}p)

mkdir -p $OUT_p $OUT_unp

#Run fastqc on paired files
fastqc -o $OUT_p -t $NSLOTS $IN_PAIRED

#Run fastqc on unpaired files
fastqc -o $OUT_unp -t $NSLOTS $IN_unPAIRED
