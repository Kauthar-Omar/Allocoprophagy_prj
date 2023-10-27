#!/bin/bash
#$ -cwd
#$ -N multiqc_trimmed
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID.err


#Activate the qc environment
conda activate qc

#run multiqc
INPUT_p="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/posttrim_qc/paired/"
INPUT_unp="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/posttrim_qc/unpaired/"
output_p="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/multiqc/multiqc_trimmed_paired"
output_unp="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/multiqc/multiqc_trimmed_unpaired"

#multiqc -o $output_p $INPUT_p

multiqc -o $output_unp $INPUT_unp
