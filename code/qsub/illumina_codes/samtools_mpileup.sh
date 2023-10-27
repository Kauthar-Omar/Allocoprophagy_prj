#!/bin/bash
#$ -cwd 
#$ -N samtools_mpileup 
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-285
# -t paired = 95 + unpaired  95x2

conda activate align

# Defining input directory
OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta"
SORT_DIR="$OUT_DIR/Rnor_6.0_alignments"

# Getting .bam path per sample 
BAM=$(ls $SORT_DIR/*/*_Rnor_6.0_sorted.bam | sort | sed -n ${SGE_TASK_ID}p)
SAMPLE=$(basename $BAM | sed 's/_Rnor_6.0_sorted.bam//;s/_R1//;s/_R2//')
READS=$(basename $BAM | sed "s/${SAMPLE}_//;s/R1_Rnor_6.0_sorted.bam/R1_unpaired/;s/R2_Rnor_6.0_sorted.bam/R2_unpaired.bam/;s/Rnor_6.0_sorted.bam/paired/")


echo ${SGE_TASK_ID} "file:"$BAM "sample:"$SAMPLE 


#### FOLLOWING LINES ARE FOR THE `samtools mpileup` ####
#   output in a dir per sample - 3 files per chr

PUP_DIR="$OUT_DIR/Rnor_6.0_alignments/pileup/$SAMPLE"
mkdir -p $PUP_DIR

for CHR in {1..20..1}; do #TODO
    echo -e "\nchr"$CHR

    PUP=$PUP_DIR/${READS}_chr${CHR}.pup

# With --ff 12 I'm selecting only both mapped reads (in case of pair, both mate map)
# With -xA I'm keeping anomalous reads and overlapping ones
# could add something about only mapping to the same chr by `samtools view -e "rname==rnext"` 
#   NB: this should be done only on paired, not on unpaired

        samtools mpileup --ff 12 -xA -r $CHR $BAM \
            --no-output-ins --no-output-ins \
            --no-output-del --no-output-del \
            --no-output-ends > $PUP

done

