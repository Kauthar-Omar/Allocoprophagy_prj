#### ARGUMENTS:
args = commandArgs(trailingOnly=TRUE)
wd=args[1] # working dir .../sample_summaries/

#setwd("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/all_cecum_whole/flow_cell_2_corrected/")

setwd("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/")

#setwd("/nfs/users/abaud/fmorillo/P50/mixup/output/sample_summaries/") #F. Set the folder for input and saving files
pair_results <- sample_results <- NULL
#for(chr in 1:19) { #F. changed to 20 chromosomes
for(chr in 1:20) {
  cat(chr, "\n")
  
  file <- paste0("pair_results_chr", chr, ".rds")
  if(file.exists(file)) {
    x <- readRDS(file)
    if(is.null(pair_results)) {
      pair_results <- x
    } else {
      stopifnot(length(x) == length(pair_results))
      x <- x[names(pair_results)]
      
      for(i in seq_along(pair_results)) {
        stopifnot(dim(x[[i]]) == dim(pair_results[[i]]),
                  all(rownames(x[[i]]) == rownames(pair_results[[i]])))
        pair_results[[i]] <- pair_results[[i]] + x[[i]]
      }
    }
  }
  
  file <- paste0("sample_results_chr", chr, ".rds")
  if(file.exists(file)) {
    x <- readRDS(file)
    if(is.null(sample_results)) {
      sample_results <- x
    } else {
      stopifnot(length(x) == length(sample_results))
      x <- x[names(sample_results)]
      
      for(i in seq_along(sample_results)) {
        stopifnot(dim(x[[i]]) == dim(sample_results[[i]]),
                  all(rownames(x[[i]]) == rownames(sample_results[[i]])))
        sample_results[[i]] <- sample_results[[i]] + x[[i]]
      }
    }
  }
}

saveRDS(pair_results, file="pair_results_allchr.rds")
saveRDS(sample_results, file="sample_results_allchr.rds")
