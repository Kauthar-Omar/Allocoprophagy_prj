# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N multiqc_raw
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.err

#Activate the qc environment
conda activate qc

#run multiqc
INPUT="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/fastqc/"
output="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/multiqc/multiqc_raw/"

mkdir -p /users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/multiqc/

multiqc -o $output $INPUT
