library(lineup2)
library(broman) #F. Run the library
library(mbmixture) #F. Run the library
library(parallel) #F. Run the library

# Setting outdir
# outdir=("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/all_cecum_whole/flow_cell_2_corrected/")
# 
# # Loading sample_results and saving distances_results
# dir = ("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/all_cecum_whole/flow_cell_2_corrected/")

# Setting outdir
outdir=("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/")

# Loading sample_results and saving distances_results
dir = ("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/")


samp <- readRDS(file=paste0(dir,"sample_results_allchr.rds"))

# calculate proportion of mismatches at homozygous loci
if(!file.exists(paste0(dir,"single_results.rds"))){
  message("creating file ", paste0(dir,"single_results.rds"))
  f <- function(a) {
    x <- apply(a, 1, function(b) (b[1,2] + b[3,1]) / sum(b[1,] + b[3,]))
    x[rownames(samp[[1]])] }
  samp_p <- t(sapply(samp, f))

  saveRDS(samp_p, file=paste0(dir,"single_results.rds"))
}
#samp <- readRDS(paste0(dir, "sample_results_allchr.rds")) 
message("loading samp_p from ", paste0(dir,"single_results.rds"))
samp_p <- readRDS(file=paste0(dir,"single_results.rds"))


# Loading pair_results and saving mixture_results
pair <- readRDS(paste0(dir, "pair_results_allchr.rds"))

# NB: this step exec with 
if(!file.exists(paste0(dir,"mixture_results.rds"))){
  startTime <- Sys.time()
  message("creating file ", paste0(dir,"mixture_results.rds"))
  n_cores <- detectCores()
#  n_cores <- 6
  message("detected ", n_cores, " cores")
  analyze_one <- function(i) {
    cat("analyzing element ", i, " of pair") 
	  res <- matrix(nrow=nrow(pair[[i]]), ncol=5)
	  
	  for(j in 1:nrow(pair[[i]])) {
	    if(names(pair)[i] == rownames(pair[[i]])[j]) next
	    res[j,] <- tmp <- mle_pe(pair[[i]][j,,,])
	  }
	  
	  dimnames(res) <- list(rownames(pair[[i]]), names(tmp))
    res
  }
  
  message("starting mclapply function, using ", n_cores, " cores") 
  result <- mclapply(seq_along(pair), analyze_one, mc.cores=n_cores)
  names(result) <- names(pair)
  
  saveRDS(result, file=paste0(dir,"mixture_results.rds"))
  endTime <- Sys.time()
  message("started at: ", startTime, ";\t ended at: ", endTime)
}else{
	message("file ", paste0(dir,"mixture_results.rds"), " already existed")
}
# message("loading mixture from ", paste0(dir,"mixture_results.rds"))
# mixture <- readRDS(paste0(dir,"mixture_results.rds"))


# Calculate mixture with SE
# TODO - STILL TO IMPROVE, I STILL GET SOME ERROR 
startTime <- Sys.time()
if(!file.exists(paste0(dir,"mixture_results_SE.rds"))){
	startTime <- Sys.time()
	message("creating file ", paste0(dir,"mixture_results_SE.rds"))
	n_cores <- detectCores()
  #  n_cores <- 6
  message("detected ", n_cores, " cores")
  analyze_one_SE <- function(i) {
    cat("analyzing element ", i, " of pair") 
    res <- matrix(nrow=nrow(pair[[i]]), ncol=5)
    
    # need to set a min of the interval for which don't have this error:
    #   Error in mbmix_loglik(tab, theta[1], theta[2]) : p >= 0 is not TRUE
    # apparently 1.8e-05 seems to be working with 5 samples (i =1,3,500,400,375)
    for(j in 1:nrow(pair[[i]])) {
      if(names(pair)[i] == rownames(pair[[i]])[j]) next
      res[j,] <- tmp <- mle_pe(pair[[i]][j,,,],interval = c(1.8e-05, 1), SE=T) 
    }
    
    dimnames(res) <- list(rownames(pair[[i]]), names(tmp))
    res
  }
  
  message("starting mclapply function, using ", n_cores, " cores") 
  # Get an estimate of the time for 100 samples
  # system.time(result_SE <- mclapply(seq(1,100,1), analyze_one_SE, mc.cores=n_cores)) 
  result_SE <- mclapply(seq_along(pair), analyze_one_SE, mc.cores=n_cores)
  names(result_SE) <- names(pair)
  
  saveRDS(result_SE, file=paste0(dir,"mixture_results_SE.rds"))
  endTime <- Sys.time()
  message("started at: ", startTime, ";\t ended at: ", endTime)
} 

