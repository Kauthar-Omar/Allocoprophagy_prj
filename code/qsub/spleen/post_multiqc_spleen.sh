# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N multiqc_spleen_postQC_paired
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.err

#Activate the qc environment
conda activate qc

#run multiqc
INPUT="/users/abaud/komar/P50/allocoprophagy/output/spleen/spleen_posttrim_qc/paired/"
output="/users/abaud/komar/P50/allocoprophagy/output/spleen/multiqc/multiqc_postQC_paired/"

mkdir -p $output

multiqc -o $output $INPUT
