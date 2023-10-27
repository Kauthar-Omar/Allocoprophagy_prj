#### ARGUMENTS:
### TODO: change all to optional arguments - easier to control
args = commandArgs(trailingOnly=TRUE)
readcounts_dir=args[2] #.../readcount
chr=args[1] # just number
#snpcalls_dir=args[3]
#readcount_dir_basename=args[4]
outdir=args[3] # .../sample_summaries/

# get summaries for each MB sample against all DNA samples, one chr

##F.CHANGING NAME OF DIRECTORY
#snpcalls_dir <- "../SnpCalls"
snpcalls_dir <- "/users/abaud/komar/P50/allocoprophagy/output/genotypes/32_rats/rdata/"
# inserted as args[3]
##H. CHANGING NAME OF DIRECTORY
#readcounts_dir <- "../Readcounts"
#readcounts_dir <- "/users/abaud/htonnele/P50/mixup/output/alignments/Rnor_6.0/readcount" 
# inserted as args[2]

#chr <- SUB #??? WTF about this SUB???
#chr=1 #remeber to hash out
# inserted as args[1]
#readcounts_dir <- "/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/readcount/all_cecum_whole/flow_cell_1" #remeber to hash out
#outdir <- "/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/all_cecum_whole/flow_cell_1/"
# readcount_dir_basename <- "flow_cell_2/"
#readcount_dir_basename <- "flow_cell_2/"
readcount_dir_basename <- "flow_cell_2_corrected/"
# inserted as args[4]

##F. CHANGING WAY OF LISTING FILES
## load the corresponding imputed SNPs for that chromosome
#load(paste0(snpcalls_dir, "/imp_snp_", chr, "_modified.RData"))
load(paste0(snpcalls_dir, "/imp_snp_", chr, ".RData")) #removed "modified"
#snpinfo$pos_bp <- round(snpinfo$pos_Mbp * 1e6) #we can keep ou "pos" column

## H. inserted this line to know genotyped samples to filter mb data
gen_NAMES <- rownames(imp_snps) #need to know genotyped IDs

##H. CHANGING WAY OF LISTING FILES
#files <- list.files(readcounts_dir, pattern=paste0("_", chr, "_"))
#samples <- sapply(strsplit(sapply(strsplit(files, "sample"), "[", 2), "_"), "[", 1)
#mb_ids <- paste0("DO-", samples)
sample_dirs <- list.dirs(readcounts_dir, recursive=F)

##H. Match genotyped IDs with sample IDs
#samples_all <- sapply(strsplit(sapply(strsplit(sample_dirs, "readcount/"), "[", 2), "/"),"[", 1) 
#samples_all <- sapply(strsplit(samples_all, "_"), "[",1)
#if(!all(nchar(samples_all)>=10)){
#  for(i in seq_along(samples_all)){
#    if(nchar(samples_all[i])<10){samples_all[i] <- paste0("000", samples_all[i])}
#  }
#}
#selected <- match(gen_NAMES, samples_all)

samples_all <- sapply(strsplit(sapply(strsplit(sample_dirs, readcount_dir_basename), "[", 2), "_"),"[", 1) 

#selected <- match(gen_NAMES, samples_all)


#files <- list.files(sample_dirs[selected], pattern=paste0("chr",chr, "_readcount.rds"), full.names=T) #works if the no is not the same I removed selected
files <- list.files(sample_dirs, pattern=paste0("chr",chr, "_readcount.rds"), full.names=T)
samples <- sapply(strsplit(sapply(strsplit(files, readcount_dir_basename), "[", 2), "_"),"[", 1)
#samples <- sapply(strsplit(samples, "_"), "[",1)
##H. ADDING 0s to sample names that don't have them - to align with IDs in genotypes
#if(!all(nchar(samples)>=10)){
#	for(i in seq_along(samples)){
#		if(nchar(samples[i])<10){samples[i] <- paste0("000", samples[i])}
#	}
#}

##H. MODIFYING FOR OUR SAMPLE NAMES
#mb_ids <- paste0("DO-", samples)
mb_ids <- samples

# check that all IDs with imp_snps data
stopifnot(all(mb_ids %in% rownames(imp_snps))) 
sample_results <- pair_results <- vector("list", length(files))
names(sample_results) <- names(pair_results) <- mb_ids

for(indi in seq_along(files)) {
  cat("file", indi, "of", length(files), "\n") 
  file <- files[indi]
  sample <- samples[indi]
  mb_id <- mb_ids[indi]

#for(indi in seq_along(files[c(1,2)])) {
#  cat("file", indi, "of", length(files), "\n") 
#  file <- files[indi]
#  sample <- samples[indi]
#  mb_id <- mb_ids[indi]
  
  # read the read counts
##H. Correcting the reading files for our path
#  readcounts <- readRDS(file.path(readcounts_dir, file))
  readcounts <- readRDS(file.path(file))
  
  # find the reads' SNP positions in the snpinfo table
  #snpinfo_row <- match(readcounts$pos, snpinfo$pos_bp)
  snpinfo_row <- match(readcounts$pos, snpinfo$pos) #removed "_bp"
  
  # should all have been found
  stopifnot(!any(is.na(readcounts$pos)))
  
  # column in genotype file
  imp_snps_col <- snpinfo$gencol[snpinfo_row]
  
  #check id there is an allele swap
  #stopifnot(all(snpinfo[imp_snps_col ,"allele1"] == readcounts[,"allele2"]))
  #stopifnot(all(snpinfo[imp_snps_col ,"allele2"] == readcounts[,"allele1"]))
  
  #Solution to the allele swap
  #renaming readcounts columns as they are the opposite of the snps from the genotypes
  colnames(readcounts) = c("pos", "allele2", "allele1", "count2", "count1")
  
  stopifnot(all(snpinfo[imp_snps_col ,"allele1"] == readcounts[,"allele1"]))
  stopifnot(all(snpinfo[imp_snps_col ,"allele2"] == readcounts[,"allele2"]))
  
  # create object to contain the results for the single samples
  sample_results[[indi]] <- array(0, dim=c(nrow(imp_snps), 3, 2))
  dimnames(sample_results[[indi]]) <- list(rownames(imp_snps), c("AA", "AB", "BB"), c("A", "B"))
  
  # byH. count As and Bs in mb sample at each type of g locus: j 1(homo A); 2(hetero); 3(homo BB)
  #i = 1 # run when getting to understand each step
  #j = 1 # run when getting to understand each step
  for(i in 1:nrow(imp_snps)) {
    g <- imp_snps[i, imp_snps_col]
    for(j in 1:3) {
      sample_results[[indi]][i,j,1] <- sum(readcounts$count1[!is.na(g) & g==j])
      sample_results[[indi]][i,j,2] <- sum(readcounts$count2[!is.na(g) & g==j])
    }
  }

  # create object to contain the results for sample pairs
  pair_results[[indi]] <- array(0, dim=c(nrow(imp_snps), 3, 3, 2))
  dimnames(pair_results[[indi]]) <- list(rownames(imp_snps), c("AA", "AB", "BB"),
                                         c("AA", "AB", "BB"), c("A", "B"))
  
  # byH. count As and Bs in mb sample at each combination of of g with g0 loci
  g0 <- imp_snps[mb_id, imp_snps_col]
  #i=1
  for(i in 1:nrow(imp_snps)) {
    # print(i)
    g <- imp_snps[i, imp_snps_col]
    for(j in 1:3) {
      for(k in 1:3) {
        pair_results[[indi]][i,j,k,1] <- sum(readcounts$count1[!is.na(g0) & g0==j & !is.na(g) & g==k])
        pair_results[[indi]][i,j,k,2] <- sum(readcounts$count2[!is.na(g0) & g0==j & !is.na(g) & g==k])
      }
    }
  }
  
} # loop over MB samples

#F. just set it to save the output files in the same folder
#setwd("/nfs/users/abaud/fmorillo/P50/mixup/output/sample_summaries/") #Set the folder for saving the files
#saveRDS(sample_results, paste0("sample_results_chr", chr, ".rds"))
#saveRDS(pair_results, paste0("pair_results_chr", chr, ".rds"))




saveRDS(sample_results, paste0(outdir,"sample_results_chr", chr, ".rds"))
saveRDS(pair_results, paste0(outdir,"pair_results_chr", chr, ".rds"))

