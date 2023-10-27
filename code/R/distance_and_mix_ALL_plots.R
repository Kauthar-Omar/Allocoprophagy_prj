### ARGUMENTS
args = commandArgs(trailingOnly=TRUE)
dir=args[1] # .../sample_summaries/
plot_dir=args[2] # P50/mixup/plot/...

# dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecum_whole/round1/"
dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_squeezed/flow_cell_2_corrected/"

# plot_dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecum_whole/round1/"
plot_dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_squeezed/flow_cell_2_corrected/"

#install.packages("lineup2") #F. Install the package
library(lineup2)
#install.packages("broman") #F. Install the package
library(broman) #F. Run the library

#install.packages("mbmixture") #F. Install the package
library(mbmixture) #F. Run the library
#install.packages("parallel") #F. Install the package
library(parallel) #F. Run the library

#t=1
#dir = paste0("~/P50/mixup/output/subsample/",t,"_77E7C80_00077E98E9/sample_summaries/")
#args[1]="~/P50/mixup/output/subsample/1.003_77E7C80_00077E98E9/sample_summaries/"
#args[2]="~/P50/mixup/plot/subsample/1.003_77E7C80_00077E98E9/"

samp_p <- readRDS(file=paste0(dir,"single_results.rds"))

#TODO check this
# get ylim and xlim based on max(samp_p)

# plot of best vs self-self distances
#H. added 3 lines to get xlim and ylim depending on the data
self <- get_self(samp_p)
best <- get_best(samp_p)

xy_lim <- round(c(max(self,na.rm=T), max(best,na.rm=T)) + 0.05, 2)

message("plotting to ", paste0(plot_dir,"distance_selfVSbest_all_no_labels.png"),"; with xlim: ", xy_lim[1], "\tylim:",  xy_lim[2])
png(file=paste0(plot_dir,"distance_selfVSbest_all_no_labels.png"))#,width=700, height=580)
grayplot(get_self(samp_p), get_best(samp_p),
	 xlab="Self-self distance", ylab="Best distance",
	 xlim=c(0, xy_lim[1]), ylim=c(0, xy_lim[2]), xaxs="i", yaxs="i")
dev.off()

# self
# best
# text(get_self(samp_p), get_best(samp_p), rownames(samp_p))
# xy_lim <- round(c(max(self,na.rm=T), max(best,na.rm=T)) + 0.05, 2)
# 
# ?text

self <- get_self(samp_p)
best <- get_best(samp_p)

xy_lim <- round(c(max(self,na.rm=T), max(best,na.rm=T)) + 0.05, 2)
message("plotting to ", paste0(plot_dir,"distance_selfVSbest_all_named.png"),"; with xlim: ", xy_lim[1], "\tylim:",  xy_lim[2])
png(file=paste0(plot_dir,"distance_selfVSbest_all.png"))#,width=700, height=580)

grayplot(get_self(samp_p), get_best(samp_p),
         xlab="Self-self distance", ylab="Best distance",
         xlim=c(0, xy_lim[1]), ylim=c(0, xy_lim[2]), xaxs="i", yaxs="i")
text(get_self(samp_p), get_best(samp_p), rownames(samp_p), pos = 3) #if plot is crowded harsh it out
dev.off()

# ?grayplot

result <- readRDS(file=paste0(dir,"mixture_results.rds")) 
# result
# getting max lrt in each sample
maxlrt <- t(sapply(result, function(a) { a[which.max(a[,4]), c(1,4)] }))
maxlrt[order(maxlrt[,2]),]
# maxlrt
message("plotting to ", paste0(plot_dir,"maxMixture_all.png"))
png(file=paste0(plot_dir,"maxMixture_all.png"))
grayplot(maxlrt[,1], maxlrt[,2]/10^5,
         xlab=expression(hat(p)), ylab=expression('LRT for p=0 (/ 10'^5*')'), main ="all samples")
text(maxlrt[,1], maxlrt[,2]/10^5, rownames(maxlrt), pos = 3)
dev.off()


#trying stuff from lobo et al
# # #Mixture per sample
# message("plotting to ", paste0(plot_dir,"Mixture_02.png"))
# # # png(file=paste0(plot_dir,"Mixture_021.png"))
grayplot((result[[7]][,1]), (result[[7]][,4])/10^4,
         xlab=expression(hat(p)), ylab="LRT for p=0 ( /10^4 )", main = 'Sample mixture for rat 025 cecal squeezed')
# text(result[[16]][,1], (result[[16]][,4])/10^4, rownames(result[[16]]))
# dev.off()
# 
likelihood_ratio_stats_011_S <- result[[1]][,4]
# p_values = 1 - pchisq(2 * likelihood_ratio_stats_011_S, df = 1, lower.tail = F) #computer doesn't bother with small values.
p_values = pchisq(2 * likelihood_ratio_stats_011_S, df = 1, lower.tail = F)


#Loop implementation for code below.
# List of sample values round1 i.e only mixtures from paired flowcell2
# samples <- c("005", "006", "007", "008", "013", "014", "015", "016","021", "022", "023", "024", "029",
#              "030", "031", "032")


# List of sample values wc flowcell 1 and 2
# samples <- c("002", "004", "005", "006", "007", "008", "010", "012", "013", "014", "015", "016", "018", "020",
#             "021", "022", "023", "024", "026", "028", "029", "030", "031", "032")

# List of sample values flowcell 2 corrected
# samples <- c("002", "004", "005", "006", "007", "008", "010", "012", "013", "014", "015", "016", "018", "020", 
#              "021", "023", "024", "026", "028", "029", "030", "031", "032")

# # List of sample values sc and lc flowcell 1 and 2
samples <- c("001", "003", "009", "011", "017", "019", "025", "027")

# List of sample values fecal flowcell 1 
# samples <- c("003", "005", "007", "009", "011", "013", "015", "017", "019", "021", "023", "025", "027", "029", "031")

# Loop through each sample
for (i in seq_along(samples)) {
  sample <- samples[i]
  message("Plotting for sample ", sample)
  
  # Construct the file name and open PNG file
  png_file <- paste0(plot_dir, "Mixture_", sample, ".png")
  png(file = png_file)
  
  # Get the corresponding result for the current sample
  current_result <- result[[i]]
  
  # Generate plot
  grayplot(current_result[, 1], current_result[, 4] / 10^4,
           xlab = expression(hat(p)), ylab = "LRT for p=0 ( /10^4 )",
           main = paste("Sample mixture for rat", sample, "caecal leftover"))
  
  text(current_result[, 1], current_result[, 4] / 10^4, rownames(current_result))
  
  # Close the PNG file
  dev.off()
}




###MANY PLOTS ON A SINGLE GRAPH
# Set the number of rows and columns for the layout
num_rows <- 2
num_cols <- 3

# Calculate the total number of plots and the number of graph papers needed
total_plots <- length(samples)
total_graph_papers <- ceiling(total_plots / (num_rows * num_cols))

# Loop through each graph paper
for (paper in 1:total_graph_papers) {
  message("Plotting graph paper ", paper)
  
  # Calculate the starting and ending indexes for the current graph paper
  start_index <- (paper - 1) * (num_rows * num_cols) + 1
  end_index <- min(paper * (num_rows * num_cols), total_plots)
  
  # Construct the file name and open PNG file
  png_file <- paste0(plot_dir, "GraphPaper_", paper, ".png")
  png(file = png_file)
  
  # Set the plotting layout for the current graph paper
  par(mfrow = c(num_rows, num_cols))
  
  # Loop through the samples on the current graph paper
  for (i in start_index:end_index) {
    sample <- samples[i]
    message("Plotting for sample ", sample)
    
    # Get the corresponding result for the current sample
    current_result <- result[[i]]
    
    # Generate plot
    grayplot(current_result[, 1], current_result[, 4] / 10^4,
             xlab = expression(hat(p)), ylab = "LRT for p=0 ( /10^4 )",
             main = paste("Sample", sample, "caecal leftover"))
    
    #text(current_result[, 1], current_result[, 4] / 10^4, rownames(current_result))
  }
  
  # Close the PNG file
  dev.off()
}

