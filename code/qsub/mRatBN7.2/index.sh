#!/bin/bash
#$ -cwd 
#$ -N index_sorted_mRatBN7.2_bam
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-285

## Defining input/output

# DATA: folder with
DATA="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sorted"

# going through the list of "R1" files - i.e. one per sample - i.e. 1 per task
BAM=$(ls $DATA/*.bam | sort | sed -n ${SGE_TASK_ID}p)

NAME=$(basename $BAM | sed 's/.bam//')


#Activating conda environment for analysis
conda activate align

#### INDEXING BAM FILES ####

samtools index $DATA/${NAME}.bam
