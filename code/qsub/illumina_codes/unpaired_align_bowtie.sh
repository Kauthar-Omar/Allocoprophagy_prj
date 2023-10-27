#!/bin/bash
#$ -cwd 
#$ -N unpaired_align_bowtie_Rnor_6.0
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -m abe
#$ -M kauthar.omar@crg.eu
#$ -pe smp 2
#$ -t 1-190

#Activating conda environment for analysis
conda activate align

#Alignment of unpaired reads

# INDEX: folder where bowtie2 index is, TODO change if changing reference genome, e.g. to mRat7
INDEX="/users/abaud/data/secondary/indexes/bowtie2/Rnor_6.0"

# DATA: folder with .fastq cleaned - UNPAIRED
DATA="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/trimming/unpaired"

# OUT: output folder for alignemnt - UNPAIRED
OUT="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/Rnor_6.0_alignments/unpaired"
mkdir -p $OUT

# going through the list of unpaired files - i.e. TWO per sample R1 and R2 - i.e. 1 per task
UNP=$(ls $DATA/*_unpaired.fq.gz | sort | sed -n ${SGE_TASK_ID}p)
NAME=$(basename $UNP | sed 's/_unpaired.fq.gz//')

echo $NAME ${SGE_TASK_ID} $UNP


#### ALIGNMENT WITH BOWTIE2 ####
# Output SAM FILE: file with unpaired reads, aligned and not, in same file
# save statistic of alignments - i.e. bowtie2 stderr - in a specific file
#  sam file piped to samtools sort for sorting

bowtie2 --threads $NSLOTS -x $INDEX/Rnor_6.0 -U $UNP 2> $OUT/${NAME}_Rnor_6.0.stat | samtools sort > $OUT/${NAME}_Rnor_6.0_sorted.bam

#indexing
#samtools index $OUT/${NAME}_Rnor_6.0_sorted.bam
