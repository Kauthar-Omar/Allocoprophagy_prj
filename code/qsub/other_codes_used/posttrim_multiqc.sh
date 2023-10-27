# This qsub script runs fastqc in raw fastq files

#!/bin/bash
#$ -cwd
#$ -N multiqc_trimmed
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.err

#Activate the qc environment
conda activate qc

#run multiqc
input_paired="/users/abaud/komar/P50/allocoprophagy/output/posttrim_qc/paired/"
input_unpaired="/users/abaud/komar/P50/allocoprophagy/output/posttrim_qc/unpaired/"
output_paired="users/abaud/komar/P50/allocoprophagy/output/multiqc/multiqc_trimmed/paired/"
output_unpaired="users/abaud/komar/P50/allocoprophagy/output/multiqc/multiqc_trimmed/unpaired/"

#run multiqc on paired
multiqc -o $output_paired $input_paired

#run multiqc on unpaired
multiqc -o $output_unpaired $input_unpaired