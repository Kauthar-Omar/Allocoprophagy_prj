#!/bin/bash
#$ -cwd 
#$ -N readcount  
#$ -o /users/abaud/komar/P50/allocoprophagy/output/logs/$JOB_NAME.$JOB_ID/$TASK_ID.log
#$ -e /users/abaud/komar/P50/allocoprophagy/output/error/$JOB_NAME.$JOB_ID/$TASK_ID.err
#$ -l virtual_free=20G
#$ -t 1-95

# This qsub does two things for each sample (1 sample = 1 task):
# 	1. Filters .pup (paired and unpaired) keeping only positions present in genotype files
# 		Use AWK - inputs are paired/unpairedR1/R2 per chromosome per sample
# 		Create a tmp directory for the sample in which store files: 1 file per chromosome with pup (pileup) from paired, unpaired R1/R2 for that chr
# 		--> filtered_chr${CHR}.pup
# 	2. Do readcount on filtered_chr$CHR.pup - done per chr / per sample again
# 		Use custom RSCRIPT - adapted from the one from Lobo et al. - NB: the way of getting the pup was different - they used R, we use samtools directly
# 	(at the end delete the tmp filtered file)


# setting Rscript to use - for step 2.
CODE_DIR="/users/abaud/htonnele/PRJs/P50/mixup/code"
RCODE="$CODE_DIR/R/get_readcounts_from_mp_v2.R"

# setting input dirs
OUT_DIR="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta" 
PUP_DIR="$OUT_DIR/Rnor_6.0_alignments/pileup" # PILEUPS
GENO_DIR="/users/abaud/htonnele/PRJs/P50/mixup/output/genotype" # GENOTYPED POSITIONS

# Selecting sample from list of dirs in pileup/ ($PUP_DIR)
# NB: for the directory, only the dir name is retained, NOT THE ABSOLUTE PATH
SAMPLE_DIR=$(ls -d $PUP_DIR/* | sort | sed -n ${SGE_TASK_ID}p)
SAMPLE=$(basename $SAMPLE_DIR)

# Temporary dir (created and then removed) 
# used to filter pileup with awk for genotyped SNP positions BEFORE readcount
TMP_SAMPLE=$OUT_DIR/tmp/$SAMPLE
mkdir -p $TMP_SAMPLE

echo -e ${SGE_TASK_ID} $SAMPLE_DIR 

# Creating count_dir for sample - store readcount per chr
# e.g. will have readcount/$sampleid/chr10_readcount.rds ...

COUNT_DIR="$OUT_DIR/Rnor_6.0_alignments/readcount/${SAMPLE}"
mkdir -p $COUNT_DIR


# Filtering for genotypes with 'awk' - for faster and lighter computational analysis in R
# AWK going through all pileups (paired, unp_R1, unp_R2) together 
# --> in the filtered_chr$CHR.pup I have all 3 of them
#
# Explanation of awk command: 
# 	inputs are: - NB per chr! 
# 		FIRST file: the one with info on genotyped positions (i.e. position saved from genotype file)
# 		2nd-Nth files: paired/unpairedR1/R2 files for the corresponding
# 	
# 	awk has 2 commands:
# 		a.'NR == FNR{A[$2]=1 ; next}'
# 			- from the FIRST file (the one coming from genotype) - 
# 				'NR == FNR' - as long as the Number of Record == FileNumber of Records - 
# 				this is true only for the first file as the NR is cumulative while FNR get reset for each file
# 			- takes the positions and store them in an array with: index = position; value is not relevant (here is 1)
# 				'{A[$2]=1 ; next}'
# 		b. '$2 in A {print}'
# 			- for the rest of the files; print the line only when the second field (i.e. the position) 
# 			  is in the array as a key/index (where all genotyped positions are stored)
# 		    --> done for all files after the first one; 

conda activate R

for CHR in {1..20..1}; do

	### 1. FILTERING PUP KEEPING ONLY GENOTYPED POSITIONS ####
	
	awk 'NR==FNR { A[$2]=1 ; next }; $2 in A {print}' \
		$GENO_DIR/chr${CHR}_pos_alleles.tsv \
		$SAMPLE_DIR/*chr${CHR}.pup \
		> $TMP_SAMPLE/filtered_chr${CHR}.pup
	
	### 2. SAVING READCOUNT IN FORMAT AS REQUIRED FOR BROMAN SCRIPTS ###

	#NB: in $RCODE, files in --sample dir are identified as "*_chr${CHR}.pup" 
	Rscript --vanilla $RCODE \
		--sample $TMP_SAMPLE \
		--geno $GENO_DIR \
		--chr $CHR \
		--out $COUNT_DIR/chr${CHR}_readcount.rds;
done

# remove temp dir TODO - comment this line if want to keep it e.g. when testing and want to check the output of filtering
rm -r $TMP_SAMPLE


#gzip $SAMPLE_DIR/*

#qsub readcount.sh
