#!/bin/bash
#$ -cwd
#$ -N mapped_paired_mRatBN7.2_counts
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID.err
#$ -m abe 
#$ -M kauthar.omar@crg.eu 
#$ -l h_rt=11:00:00
#$ -q long-sl7

conda activate align

bash /users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/code/bash/mRatBN7.2/paired_mapped_counts.sh
