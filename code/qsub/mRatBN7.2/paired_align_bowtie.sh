#!/bin/bash
#$ -cwd 
#$ -N paired_align_bowtie_mRatBN7.2
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -m abe
#$ -M kauthar.omar@crg.eu
#$ -pe smp 4
#$ -t 1-95
#$ -l virtual_free=15G,h_rt=16:00:00
#$ -q long-sl7

## Defining input/output

# INDEX: folder where bowtie2 index is, TODO change if changing reference genome, e.g. to mRat7
INDEX="/users/abaud/komar/P50/allocoprophagy/data/reference_genome/mRatBN7.2"
# DATA: folder with .fastq cleaned - paired
DATA="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/trimming/paired"

# OUT: output folder for alignemnt 
OUT="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/paired_alignments_stat"
OUT_SORTED="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sorted"

mkdir -p $OUT $OUT_SORTED

# going through the list of "R1" files - i.e. one per sample - i.e. 1 per task
R1=$(ls $DATA/*_R1_paired.fq.gz | sort | sed -n ${SGE_TASK_ID}p)

# getting sample name
NAME=$(basename $R1 | sed 's/_R1_paired.fq.gz//')

# correpondent R2 file
R2=$(echo $R1 | sed 's/_R1_/_R2_/')

echo $NAME ${SGE_TASK_ID} $R1 $R2

#Activating conda environment for analysis
conda activate align

#### ALIGNMENT WITH BOWTIE2 ####
# Output SAM FILE: file with paired reads, aligned and not, in the same file
# save statistic of alignments - i.e. bowtie2 stderr - in a specific file

bowtie2 --threads $NSLOTS -x $INDEX/mRatBN7.2 -1 $R1 -2 $R2 2> $OUT/${NAME}_mRatBN7.2.stat | samtools sort > $OUT_SORTED/${NAME}_paired.bam

#Indexing sorted bam file
#samtools index $OUT_SORTED/${NAME}_Rnor_6.0_sorted.bam 

