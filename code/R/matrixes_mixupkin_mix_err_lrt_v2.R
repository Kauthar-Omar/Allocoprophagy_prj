# Setting outdir
outdir=("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/")

# Loading sample_results and saving distances_results
dir = ("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/")

#Loading GRM
#load("/users/abaud/data/secondary/P50/GRM.RData")

# Reading mixture results:
mixture <- readRDS(paste0(dir,"mixture_results.rds"))

# Removing swaps for now, should correct for them later
#swaps = c("00077E75B2","00077E8DD5","00077E8F97","00077E9235")
#mixture <- mixture[!names(mixture) %in% swaps]
#names(mixture)

#Removing swaps for now, should correct for them.
#Corrected that is why code below hashed out.
# swaps = c("022","032")
# mixture <- mixture[!names(mixture) %in% swaps]
# names(mixture)

#creating a new single.rds and matrix.rds without the two files.

# Loading cages
metadata <- read.csv("/users/abaud/komar/P50/allocoprophagy/data/sorted_Leah_p50_deep_metadata.csv")
metadata$new_name <- sapply(strsplit(metadata$Name, "_"), "[",1)
# Selecting only genotyped and sequenced metagenome
mixup_meta <- metadata[metadata$Material == "Cecal-Leftover" & metadata$Flow_cell == "1st",]
# Cecal-Squeezed Cecal-Whole Cecal-Leftover Fecal

#selecting only names, cages and phenotyping_center for our samples
#meta_slim <- mixup_meta[names(mixture), c("name_round8_genotypes","Cage_ID","phenotyping_center")]
matched=match(names(mixture),mixup_meta$new_name)
mixup_meta=mixup_meta[matched,]
names(mixture)
names(mixup_meta)
meta_slim <- mixup_meta[names(mixture), c("new_name","Cage_ID","Phenotyping_center")]
meta_slim <- mixup_meta[,c("new_name","Cage_ID","Phenotyping_center")]
meta_slim
#length(unique(cages[,"cage"]))
# removing NAs ones 
cages <- na.omit(meta_slim)
cages
#length(unique(cages[,"cage"]))
#cages <- cages[order(cages["cage"]),]

# Cage_matrix
eli <- cages[,c("Cage_ID", "new_name")]
cage_matrix <- crossprod(table(eli)) # NB: CM and self = 1; non CM =0
names(dimnames(cage_matrix)) <- NULL 
saveRDS(cage_matrix,file=paste0(outdir, "cage_matrix.rds"))

# selecting GRM for sample for which have cage info
#kinship <- GRM[rownames(cage_matrix), rownames(cage_matrix)]
#all.equal(rownames(cage_matrix),rownames(kinship))
#saveRDS(kinship,file=paste0(outdir, "kinship_matrix.rds"))


## selecting mixture for sample for which have cage info
mix <- mixture[rownames(cage_matrix)]
#
## getting MIXTURE matrix  
#all <- names(mix)
#mix_matrix <-  matrix(nrow=length(mix), ncol=length(mix), 
#                      dimnames = list(all, all))
#for(s in all){
#  sample <- mix[[s]]
#  mix_matrix[s,all] <- sample[all, "p"]
#}
##all.equal(rownames(kinship),rownames(mix_matrix))
#saveRDS(mix_matrix,file=paste0(outdir, "mixture_matrix.rds"))

# Getting ERROR matrix
#err_matrix <-  matrix(nrow=length(mix), ncol=length(mix),
#		      dimnames = list(all, all))

#for(s in all){
#	sample <- mix[[s]]
#	err_matrix[s,all] <- sample[all, "e"]
#}

# Getting LRT matrix
#lrt_matrix <- matrix(nrow=length(mix), ncol=length(mix),
#		     dimnames = list(all, all))
#for(s in all){
#	sample <- mix[[s]]
#	lrt_matrix[s,all] <- sample[all, "lrt_p0"]
#}

### CAN do all the same with "do.call('cbind', lapply())"
all <- names(mix)

# mix_matrix
mix_matrix <- t(do.call('cbind',lapply(mix,'[',TRUE,'p')))
mix_matrix <- mix_matrix[rownames(cage_matrix), rownames(cage_matrix)]
#stopifnot(all.equal(rownames(kinship),rownames(mix_matrix)))
saveRDS(mix_matrix,file=paste0(outdir, "mixture_matrix.rds"))

# err_matrix 
err_matrix <- t(do.call('cbind',lapply(mix,'[',TRUE,'e')))
err_matrix <- err_matrix[all, all]

#stopifnot(all.equal(rownames(kinship),rownames(err_matrix)))

saveRDS(err_matrix,file=paste0(outdir, "error_matrix.rds"))


# lrt_matrix
lrt_matrix <- t(do.call('cbind',lapply(mix,'[',TRUE,'lrt_p0')))
lrt_matrix <- lrt_matrix[all, all]
#stopifnot(all.equal(rownames(kinship),rownames(lrt_matrix)))

saveRDS(lrt_matrix,file=paste0(outdir, "lrt_p0_matrix.rds"))




