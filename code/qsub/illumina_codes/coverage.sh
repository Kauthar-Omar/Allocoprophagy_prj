#!/bin/bash
#$ -cwd 
#$ -N coverage 
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -t 1-95

conda activate align

## # trying with a list of files .paired .unpaired for same sample 
## # will not work cos they will be considered as different samples - will get report for each one of them ???
## 
## # trying with quality filters = pileup -i.w. -q0 -Q13 
## # NB: no need to put mapping filter cos of course will use only aligned reads!
## 
OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta"
SORT_DIR="$OUT_DIR/Rnor_6.0_alignments"
COVERAGE="$OUT_DIR/Rnor_6.0_alignments/coverage"
#mkdir -p $COVERAGE
#TMP_DIR="$OUT_DIR/tmp"
 
BAM=$(ls $SORT_DIR/paired/*_Rnor_6.0_sorted.bam | sort | sed -n ${SGE_TASK_ID}p)
SAMPLE=$(basename $BAM | sed 's/_Rnor_6.0_sorted.bam//')
 
# 1. create tmp folder
TMP_DIR="$OUT_DIR/tmp/$SAMPLE"
#mkdir -p $TMP_DIR
## 
## # 2. create tmp .bam (sorted and index) for paired -f 2 (only properly paired that are the ones going into pileup) 
## # to have better idea of the coverage that really goes in the analysis
## ## NB: theoretically have --rf 2 option from samtools coverage to select prop paired BUT if want to do it for P + UNP (as do it with the list), 
## ##   cannot put that option cos would be applied to unpaired, giving 0 result for those reads
TMP_BAM="$TMP_DIR/${SAMPLE}_propPaired.bam"
#samtools view -f 2 $BAM -b > $TMP_BAM 
#samtools index $TMP_BAM
## 
## # 3. create list of bam files - paired.tmp.bam + R1_unpaired.bam + R2_unpaired.bam
LIST="$TMP_DIR/bam.list"
## 
#echo $TMP_BAM $(ls $SORT_DIR/unpaired/${SAMPLE}*_Rnor_6.0_sorted.bam) | tr ' ' '\n' > $LIST
## 
## # 4. coverage
## 
## ## A. -q0 -Q13 - as in pileup
## # tab file - WG (nb: 1..20,M,X,Y)
#samtools coverage -b $LIST -q0 -Q13 > $COVERAGE/${SAMPLE}.cov
## 
## # hist per chr {1..20}
 COV_DIR=$COVERAGE/$SAMPLE # dir for histograms
mkdir -p $COV_DIR
## 
for CHR in {1..20..1}; do
 samtools coverage -A -b $LIST -q0 -Q13 -r $CHR -m > $COV_DIR/${SAMPLE}_${CHR}_hist.cov
done
## 
## ## B. -q0 -Q0 - no quality control 
## ## changes in covbases (>) - coverage (>) - meandepth (>) - meanbaseq (<, i.e. -Q) - meanmapq (=, i.e. -q)
## # tab file - WG (nb: 1..20,M,X,Y)
#samtools coverage -b $LIST -q0 -Q0 > $COVERAGE/${SAMPLE}_Q0.cov
## 
## ### (hist per chr {1..20} )
## 
## # REMOVE TEMPORARY DIR
rm -r $TMP_DIR
## 
## #from 
## #cd ~/P50/mixup/output/tests/Rnor_6.0
## #SORT_DIR=../../alignments/Rnor_6.0/sorted
## #BAM=$(ls $SORT_DIR/*.bam | sort | sed -n 1p)
## #SAMPLE=$(basename $BAM | sed 's/_paired.bam//;s/_R1_unpaired.bam//;s/_R2_unpaired.bam//')
## #READS=$(basename $BAM | sed "s/${SAMPLE}_//;s/.bam//")
## #CHR=12
## #OUT=${SAMPLE}.cov
## 
## #samtools coverage -q0 -Q13 -r $CHR $BAM -o $OUT
## 
## #samtools coverage -q0 -Q13 -o ${OUT}
## 
## #samtools coverage -q0 -Q13 -f $CHR $BAM -o ${OUT}.hist -m
## 
## # trying with NO quality filters
## #samtools coverage -q0 -Q0 -o ${OUT}
## #samtools coverage -q0 -Q0 -r $CHR $BAM -o ${OUT}.hist -m
