#!/bin/bash

#$ -cwd
#$ -N bowtie_index_mRatBN7.2
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME-$JOB_ID.out
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME-$JOB_ID.err
#$ -m abe 
#$ -M kauthar.omar@crg.eu 
#$ -l virtual_free=10G

DIR='/users/abaud/komar/P50/allocoprophagy/data/reference_genome/mRatBN7.2'

#Activate conda env
conda activate align

#Build index
#bowtie2-build -f /users/abaud/komar/P50/allocoprophagy/data/reference_genome/GCF_015227675.2_mRatBN7.2_genomic.fna /users/abaud/komar/P50/allocoprophagy/data/reference_genome/mRatBN7.2

#Build index
bowtie2-build -f $DIR/1.fasta,$DIR/2.fasta,$DIR/3.fasta,$DIR/4.fasta,$DIR/5.fasta,$DIR/6.fasta,$DIR/7.fasta,$DIR/8.fasta,$DIR/9.fasta,$DIR/10.fasta,$DIR/11.fasta,$DIR/12.fasta,$DIR/13.fasta,$DIR/14.fasta,$DIR/15.fasta,$DIR/16.fasta,$DIR/17.fasta,$DIR/18.fasta,$DIR/19.fasta,$DIR/20.fasta,$DIR/X.fasta,$DIR/Y.fasta,$DIR/MT.fasta $DIR/mRatBN7.2 > $DIR/indexing_stats.txt
