#!/bin/bash
#$ -cwd
#$ -N snp_calls
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME_$JOB_ID.log 
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME_$JOB_ID.err
#$ -m abe
#$ -M kauthar.omar@crg.eu
#$ -t 1

#CODE STILL NOT WORKING FIGURE OUT HOW TO INSTALL "genio" in R

conda activate R

# Rscript for generating snp_calls in rdata format using genio.
RCODE_1="/users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/code/R/snp_calls.R"
PLINK_DIR="/users/abaud/komar/P50/allocoprophagy/output/genotypes/all_cecum_whole_genotypes/"
PREFIX="hs_rats_n24_chr"
Rscript --vanilla $RCODE_1 $PLINK_DIR $PREFIX
