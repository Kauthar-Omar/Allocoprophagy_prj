#!/bin/bash
#$ -cwd 
#$ -N paired_align_bowtie_Rnor_6.0
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -pe smp 2
#$ -t 1-2
#$ -m abe 
#$ -M kauthar.omar@crg.eu 
#$ -l virtual_free=40G,h_rt=12:00:00
#$ -q long-sl7

## Defining input/output

# INDEX: folder where bowtie2 index is, TODO change if changing reference genome, e.g. to mRat7
INDEX="/users/abaud/data/secondary/indexes/bowtie2/Rnor_6.0"
#REF_FASTA="/users/abaud/komar/P50/allocoprophagy/data/ref_align_fasta/GCF_015227675.2_mRatBN7.2_genomic.fna"

# DATA: folder with .fastq cleaned - paired
DATA="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/trimming/paired"

# OUT: output folder for alignemnt 
OUT="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/Rnor_6.0_alignments/paired"

#mkdir -p $OUT

# going through the list of "R1" files - i.e. one per sample - i.e. 1 per task
R1=$(ls $DATA/003_L_16548AAD*_R1_paired.fq.gz $DATA/001_L_16523AAD*_R1_paired.fq.gz | sort | sed -n ${SGE_TASK_ID}p)

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

bowtie2 --threads $NSLOTS -x $INDEX/Rnor_6.0 -1 $R1 -2 $R2 2> $OUT/${NAME}_Rnor_6.0.stat | samtools sort > $OUT/${NAME}_Rnor_6.0_sorted.bam

# Convert SAM (bowtie2 output) to bam - NB: comment this line in favor of the sorting ones
#   NB: could pipe bowtie2 output to samtools sort - never did that and not sure on how it would work

# samtools view -bS $OUT/${NAME}_Rnor_6.0.sam > $OUT/${NAME}_Rnor_6.0.bam

# #Converting Bam to Cram
# # With reference
# #samtools view -C -T $REF_FASTA $OUT/${NAME}_Rnor_6.0.bam > $OUT/${NAME}_Rnor_6.0.cram

# ##Without reference
# samtools view -C --output-fmt-option no_ref -o $OUT/${NAME}_Rnor_6.0.cram $OUT/${NAME}_Rnor_6.0.bam

# # TODO UNCOMMENT FOLLOWING lines to get directly sorted and indexed bam - this avoid using of qsub/bam_sort.sh
# # NB: if do this will have to change the input folder in following step - i.e. pileup, qsub/samtools_mpileup.sh

# #samtools sort $OUT/${NAME}_Rnor_6.0.sam -o $OUT/${NAME}_Rnor_6.0_sorted.bam
# #samtools index $OUT/${NAME}_Rnor_6.0_sorted.bam 


# # remove SAM to free up space
# rm $OUT/${NAME}_Rnor_6.0.sam


# Just getting info about alignments - stdout to /dev/null and stderr to specific file
#bowtie2 --threads $NSLOTS  -x $INDEX/Rnor_6.0 -1 $R1 -2 $R2 > /dev/null 2> $OUT/2_${NAME}_Rnor_6.0.stat
