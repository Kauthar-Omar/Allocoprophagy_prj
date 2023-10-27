#!/bin/bash
#$ -cwd 
#$ -N samtools_mpileup_mRatBN7.2 
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-285
# -t paired = 95 + unpaired  95x2

conda activate align

# Defining input directory
OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/metagenomes"
SORT_DIR="$OUT_DIR/mRatBN7.2/sorted"

# Getting .bam path per sample 
BAM=$(ls $SORT_DIR/*.bam | sort | sed -n ${SGE_TASK_ID}p)
SAMPLE=$(basename $BAM | sed 's/_paired.bam//;s/_R1_unpaired.bam//;s/_R2_unpaired.bam//')
READS=$(basename $BAM | sed "s/${SAMPLE}_//;s/.bam//")

echo ${SGE_TASK_ID} "file:"$BAM "sample:"$SAMPLE 


#### FOLLOWING LINES ARE FOR THE `samtools mpileup` ####
#   output in a dir per sample - 3 files per chr

PUP_DIR="$OUT_DIR/mRatBN7.2/pileup/$SAMPLE"
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

