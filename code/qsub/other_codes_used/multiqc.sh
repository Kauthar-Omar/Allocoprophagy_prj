# This qsub script runs multiqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N multiqc_raw
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.err

#Activate the qc environment
conda activate qc

#run multiqc
INPUT="/users/abaud/komar/P50/allocoprophagy/output/fastqc/"
output="/users/abaud/komar/P50/allocoprophagy/output/multiqc/multiqc_raw/"
multiqc -o $output $INPUT
