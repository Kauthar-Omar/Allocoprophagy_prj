#!/bin/bash
#$ -cwd
#$ -N trimming_cutadapt
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID_$TASK_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID_$TASK_ID.err
#$ -pe smp 4
#$ -t 1-4

#Activate the qc environment
conda activate cutadapt

#Cutadapt input and output dirs
INPUT=$(ls /users/abaud/komar/P50/allocoprophagy/data/*R1_001.fastq.gz | sort -u | sed -n ${SGE_TASK_ID}p)
OUT="/users/abaud/komar/P50/allocoprophagy/output/trimmed_cutadapt/"
I=$(echo $INPUT | sed 's/1_001.fastq.gz//')
O=$(echo $INPUT | sed -r 's/.{43}//' | sed 's/1_001.fastq.gz//')

#Run cutadapt
cutadapt -j $NSLOTS  -q 15 -m 36 -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT -o ${OUT}/${O}1_trimmed.fq.gz -p ${OUT}/${O}2_trimmed.fq.gz ${I}1_001.fastq.gz ${I}2_001.fastq.gz 2> ${OUT}/${O}eport.txt


bowtie2 --threads 6 -x $INDEX/Rnor_6.0 -1 $DATA/024_W_16528AAD_AGCGCTTACA-TGAGGAATAC_R1_paired.fq.gz -2 $DATA/024_W_16528AAD_AGCGCTTACA-TGAGGAATAC_R2_paired.fq.gz -U $DATA/../unpaired/024_W_16528AAD_AGCGCTTACA-TGAGGAATAC_R1_unpaired.fq.gz,$DATA/../unpaired/024_W_16528AAD_AGCGCTTACA-TGAGGAATAC_R2_unpaired.fq.gz | samtools view -bS > test/024_W_16528AAD_AGCGCTTACA-TGAGGAATAC_Rnor_6.0.bam 2> 024_W_16528AAD_AGCGCTTACA-TGAGGAATAC_Rnor_6.0.stat