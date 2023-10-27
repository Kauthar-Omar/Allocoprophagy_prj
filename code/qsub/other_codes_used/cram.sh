#!/bin/bash
#$ -cwd 
#$ -N cram_conversion
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/utput/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-95

#Activating conda environment for analysis
conda activate align

# OUT: output folder for alignemnt 
OUT="/users/abaud/komar/P50/allocoprophagy/output/all_meta/Rnor_6.0_alignments/paired"

DATA=$(ls $OUT/*_Rnor_6.0_sorted.bam | sort | sed -n ${SGE_TASK_ID}p)

# getting sample name
NAME=$(basename $DATA | sed 's/_Rnor_6.0_sorted.bam//')

##Without reference
samtools view -C --output-fmt-option no_ref -o $OUT/${NAME}_Rnor_6.0_sorted.cram $OUT/${NAME}_Rnor_6.0_sorted.bam

rm $OUT/${NAME}_Rnor_6.0_sorted.bam
