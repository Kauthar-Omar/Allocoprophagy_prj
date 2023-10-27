#!/bin/bash
#$ -cwd
#$ -N trimmed_unpaired_counts
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID.err
#$ -m abe 
#$ -M kauthar.omar@crg.eu 
#$ -l virtual_free=20G,h_rt=12:00:00
#$ -q long-sl7
#$ -q long-sl7

bash /users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/code/bash/trimmed_unpaired_counts.sh
