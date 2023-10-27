#!/bin/bash
#$ -cwd 
#$ -N bam_sort 
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-4

# Defining input directories:
OUT_DIR="/users/abaud/htonnele/P50/mixup/output"
PAIRED_DIR=$OUT_DIR/alignments/Rnor_6.0/paired
UNP_DIR=$OUT_DIR/alignments/Rnor_6.0/unpaired

# Getting paths of paired and R1/R2_unpaired files
P=$(ls $PAIRED_DIR/*_Rnor_6.0.cram | sort | sed -n ${SGE_TASK_ID}p)
NAME=$(basename $P | sed 's/_Rnor_6.0.cram//')
R1=$UNP_DIR/${NAME}_R1_Rnor_6.0.cram
R2=$(echo $R1 | sed 's/_R1_/_R2_/')

echo $NAME ${SGE_TASK_ID} $P $R1 $R2

# Defining output directory
SORT_DIR=$OUT_DIR/alignments/Rnor_6.0/sorted
mkdir -p $SORT_DIR

# Defining output file names --> in sorted dir have 1041*3 files
OUT_P=$SORT_DIR/${NAME}_paired.cram
OUT_R1=$SORT_DIR/${NAME}_R1_unpaired.cram
OUT_R2=$SORT_DIR/${NAME}_R2_unpaired.cr am

#LIST=$OUT_DIR/tmp/${NAME}.file.list
echo -e $OUT_P"\n"$OUT_R1"\n"$OUT_R2 #> $LIST

samtools sort $P -o $OUT_P
samtools index $OUT_P

samtools sort $R1 -o $OUT_R1
samtools index $OUT_R1

samtools sort $R2 -o $OUT_R2
samtools index $OUT_R2