#!/bin/bash
#$ -cwd 
#$ -N index_sorted_bam_paired
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-95

## Defining input/output

# DATA: folder with
DATA="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/Rnor_6.0_alignments/paired"

# going through the list of "R1" files - i.e. one per sample - i.e. 1 per task
BAM=$(ls $DATA/*_Rnor_6.0_sorted.bam | sort | sed -n ${SGE_TASK_ID}p)

NAME=$(basename $BAM | sed 's/_Rnor_6.0_sorted.bam//')


#Activating conda environment for analysis
conda activate align

#### INDEXING BAM FILES ####

samtools index $DATA/${NAME}_Rnor_6.0_sorted.bam
