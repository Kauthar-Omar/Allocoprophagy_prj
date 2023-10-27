#!/bin/bash
#$ -cwd
#$ -N trimming
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID/$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID/$TASK_ID.err
#$ -pe smp 2
#$ -t 1-95

#Activate the qc environment
conda activate qc

#Run Trimmomatic
TRIM="/users/abaud/komar/P50/allocoprophagy/output/all_meta/trimming/logs/"
OUTP="/users/abaud/komar/P50/allocoprophagy/output/all_meta/trimming/paired/"
OUTU="/users/abaud/komar/P50/allocoprophagy/output/all_meta/trimming/unpaired/"

#creating output directories
mkdir -p $TRIM $OUTP $OUTU

ADAPT="/users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/adapters/"
INPUT=$(ls /users/abaud/komar/P50/allocoprophagy/data/cecal/*R1_001.fastq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
I=$(echo $INPUT | sed 's/1_001.fastq.gz//')
O=$(echo $INPUT | sed -r 's/.{49}//' | sed 's/1_001.fastq.gz//')
T=$(echo $INPUT | sed -r 's/.{49}//' | sed 's/_R1_001.fastq.gz//')
trimmomatic PE -threads $NSLOTS -phred33 -trimlog ${TRIM}/${T}_trimlog.txt ${I}1_001.fastq.gz ${I}2_001.fastq.gz ${OUTP}/${O}1_paired.fq.gz ${OUTU}/${O}1_unpaired.fq.gz ${OUTP}/${O}2_paired.fq.gz ${OUTU}${O}2_unpaired.fq.gz ILLUMINACLIP:${ADAPT}nextera_pe.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36