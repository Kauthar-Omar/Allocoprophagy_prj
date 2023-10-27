#!/bin/bash
#$ -cwd 
#$ -N unpaired_align_bowtie_mRatBN7.2
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -m abe
#$ -M kauthar.omar@crg.eu
#$ -pe smp 2
#$ -t 1-190


#Activating conda environment for analysis
conda activate align

#Alignment of unpaired reads

# INDEX: folder where bowtie2 index is, TODO change path to index if moved to shared folder.
INDEX="/users/abaud/komar/P50/allocoprophagy/data/reference_genome/mRatBN7.2"

# DATA: folder with .fastq cleaned - UNPAIRED
DATA="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/trimming/unpaired"

# OUT: output folder for alignemnt - UNPAIRED
OUT="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/unpaired_alignments_stat"
OUT_SORTED="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sorted"

mkdir -p $OUT #$OUT_SORTED #undo comment if you did not run paired sorted

# going through the list of unpaired files - i.e. TWO per sample R1 and R2 - i.e. 1 per task
UNP=$(ls $DATA/*_unpaired.fq.gz | sort | sed -n ${SGE_TASK_ID}p)
NAME=$(basename $UNP | sed 's/_unpaired.fq.gz//')

echo $NAME ${SGE_TASK_ID} $UNP


#### ALIGNMENT WITH BOWTIE2 ####
# Output SAM FILE: file with unpaired reads, aligned and not, in same file
# save statistic of alignments - i.e. bowtie2 stderr - in a specific file
#  sam file piped to samtools sort for sorting

bowtie2 --threads $NSLOTS -x $INDEX/mRatBN7.2 -U $UNP 2> $OUT/${NAME}_mRatBN7.2.stat | samtools sort > $OUT_SORTED/${NAME}_unpaired.bam

#indexing
#samtools index $OUT_SORTED/${NAME}_unpaired.bam
