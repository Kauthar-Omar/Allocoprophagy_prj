

#load('/nfs/leia/research/stegle/abaud/P50_HSrats/output/VD/16S_counts_new3/pruned_dosagesDGE_cageEffect/all_VCs.RData')
#work_dir = "/Users/abaud/OneDrive - CRG - Centre de Regulacio Genomica/Microbiome sample mixups/cage_effects"
work_dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/fecal/flow_cell_1/"
#load(paste(work_dir,'/all_VCs_full.RData',sep=''))
plot_dir=("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/fecal/flow_cell_1")

setwd("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/fecal/flow_cell_1")

# reading MATRIX FOR KINSHIP, CAGES, MIXTURE
mix_matrix <- readRDS(file=paste0(work_dir, "mixture_matrix.rds"))
cage_matrix <- readRDS(file=paste0(work_dir, "cage_matrix.rds"))
#err_matrix <- readRDS(file=paste0(work_dir, "error_matrix.rds"))
# lrt_matrix <- readRDS(file=paste0(work_dir, "lrt_p0_matrix.rds"))

# mix_matrix_W_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecum_whole/flow_cell_1/mixture_matrix.rds")
# new_row_names_W_1 <- paste(rownames(mix_matrix_W_1), "_W_1", sep = "")
# rownames(mix_matrix_W_1) <- new_row_names_W_1
# mix_matrix_W_2 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecum_whole/flow_cell_2_corrected/mixture_matrix.rds")
# new_row_names_W_2 <- paste(rownames(mix_matrix_W_2), "_W_2", sep = "")
# rownames(mix_matrix_W_2) <- new_row_names_W_2
# mix_matrix_L_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_1/mixture_matrix.rds")
# new_row_names_L_1 <- paste(rownames(mix_matrix_L_1), "_L_1", sep = "")
# rownames(mix_matrix_L_1) <- new_row_names_L_1
# mix_matrix_L_2 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/mixture_matrix.rds")
# new_row_names_L_2 <- paste(rownames(mix_matrix_L_2), "_L_2", sep = "")
# rownames(mix_matrix_L_2) <- new_row_names_L_2
# mix_matrix_S_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_squeezed/flow_cell_1/mixture_matrix.rds")
# new_row_names_S_1 <- paste(rownames(mix_matrix_S_1), "_S_1", sep = "")
# rownames(mix_matrix_S_1) <- new_row_names_S_1
# mix_matrix_S_2 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_squeezed/flow_cell_2_corrected/mixture_matrix.rds")
# new_row_names_S_2 <- paste(rownames(mix_matrix_S_2), "_S_2", sep = "")
# rownames(mix_matrix_S_2) <- new_row_names_S_2
# mix_matrix_F_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/fecal/flow_cell_1/mixture_matrix.rds")
# new_row_names_F_1 <- paste(rownames(mix_matrix_F_1), "_F_1", sep = "")
# rownames(mix_matrix_F_1) <- new_row_names_F_1
# # mix_df_list <- list(as.data.frame(mix_matrix_W_1), as.data.frame(mix_matrix_W_2), as.data.frame(mix_matrix_L_1), as.data.frame(mix_matrix_L_2), as.data.frame(mix_matrix_S_1), as.data.frame(mix_matrix_S_2), as.data.frame(mix_matrix_F_1))
# 
# ###Cage matrix
# cage_matrix_W_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecum_whole/flow_cell_1/cage_matrix.rds")
# new_row_names_W_1 <- paste(rownames(cage_matrix), "_W_1", sep = "")
# rownames(cage_matrix_W_1) <- new_row_names_W_1
# cage_matrix_W_2 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecum_whole/flow_cell_2_corrected/cage_matrix.rds")
# new_row_names_W_2 <- paste(rownames(cage_matrix_W_2), "_W_2", sep = "")
# rownames(cage_matrix_W_2) <- new_row_names_W_2
# cage_matrix_L_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_1/cage_matrix.rds")
# new_row_names_L_1 <- paste(rownames(cage_matrix_L_1), "_L_1", sep = "")
# rownames(cage_matrix_L_1) <- new_row_names_L_1
# cage_matrix_L_2 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_leftover/flow_cell_2_corrected/cage_matrix.rds")
# new_row_names_L_2 <- paste(rownames(cage_matrix_L_2), "_L_2", sep = "")
# rownames(cage_matrix_L_2) <- new_row_names_L_2
# cage_matrix_S_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_squeezed/flow_cell_1/cage_matrix.rds")
# new_row_names_S_1 <- paste(rownames(cage_matrix_S_1), "_S_1", sep = "")
# rownames(cage_matrix_S_1) <- new_row_names_S_1
# cage_matrix_S_2 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/cecal_squeezed/flow_cell_2_corrected/cage_matrix.rds")
# new_row_names_S_2 <- paste(rownames(cage_matrix_S_2), "_S_2", sep = "")
# rownames(cage_matrix_S_2) <- new_row_names_S_2
# cage_matrix_F_1 <- readRDS("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sample_summaries/fecal/flow_cell_1/cage_matrix.rds")
# new_row_names_F_1 <- paste(rownames(cage_matrix_F_1), "_F_1", sep = "")
# rownames(cage_matrix_F_1) <- new_row_names_F_1
# cage_matrix <- rbind(cage_matrix_W_1, cage_matrix_W_2, cage_matrix_L_1, cage_matrix_L_2, cage_matrix_S_1, cage_matrix_S_2, cage_matrix_F_1)
# 

# Check matrix have same order
stopifnot(all.equal(rownames(mix_matrix), rownames(cage_matrix)))
#stopifnot(all.equal(colnames(cage_matrix), colnames(err_matrix)))

mix_CM <- na.omit(mix_matrix[cage_matrix==1])
mix_nonCM <- mix_matrix[cage_matrix==0]

#c1 <- rgb(173,216,230,max = 255, alpha = 150, names = "lt.blue")
#as.vector(col2rgb("#E69F00"))
c1 <- rgb(230,159,0, max = 255, alpha = 150, names = "tr.yellow")
c1_full <- rgb(230,159,0, max = 255, names = "yellow")

#c2 <- rgb(255,192,203, max = 255, alpha = 150, names = "lt.pink")
#as.vector(col2rgb("#56B4E9"))
c2 <- rgb(86,180,233, max = 255, alpha = 150, names = "tr.blue")
c2_full <- rgb(86,180,233, max = 255, names = "blue")

##### Setting functions to get the histogram for mixture above threshold - default is 0
get_hist_thr <- function(mix_CM, mix_nonCM, thr=0, ylims=c(0,1)){
  high_mixCM = mix_CM[mix_CM > thr]
  high_mixnonCM = mix_nonCM[mix_nonCM > thr]
  fract_CM = length(high_mixCM) / length(mix_CM)
  fract_nonCM = length(high_mixnonCM) / length(mix_nonCM)
  
  mox_x = max(high_mixCM,high_mixnonCM)
  
  #brokes = seq(0,mox_x+0.1, by = 0.015)
  brokes = seq(0,mox_x+0.002, by = 0.002)
  # brokes = seq(0,mox_x+0.02, by = 0.02)
  #brokes = seq(0,mox_x+5, by = 5)
  
  h1 = hist(high_mixCM, breaks = brokes, plot = FALSE)
  h2 = hist(high_mixnonCM, breaks = brokes, plot = FALSE)
  
  # ==> Getting the counts as proportional to the tot count number <==
  h1$counts <- h1$counts / sum(h1$counts)
  h2$counts <- h2$counts / sum(h2$counts)
  
  mox_y = max(c(h1$counts,h2$counts))
  #mox_y=max(h1$counts) 
  
  plot <- plot(h1, col = c1, xlim = c(0,mox_x), ylim = ylims, freq = TRUE,
               xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1)
  plot2 <- plot(h2, col = c2, add=T, xlim = c(0,mox_x), ylim = ylims, freq = TRUE,
                xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1)
  #hist(all_VCs$var_Ad, add = T, col = c2, freq = TRUE, breaks = brokes)
  legend <- legend('topright',legend = c('Cage mates','Non-cage mates'), fill = c(c1,c2), cex=1.1)
#  l_pos <- c(legend$rect$left, legend$rect$top - legend$rect$h)
#  sub_gen <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
#                  labels="Plotted fraction:")
#  sub_cm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c1_full,
#                    labels=paste0(round(fract_CM,2)*100, " %"))
#  sub_noncm <- text(l_pos[1], l_pos[2], adj = c(-1,5.5), col=c2_full,
#                    labels=paste0(round(fract_nonCM,2)*100, " %"))
  
  #return(list(plot, plot2, legend, sub_cm, sub_noncm))
}

# Playing around with numbers
pdf(paste0(plot_dir,'hist_mixtures_BOTH_v2','.pdf'))
get_hist_thr(mix_CM, mix_nonCM)
get_hist_thr(mix_CM, mix_nonCM, ylim=c(0,0.5))
get_hist_thr(mix_CM, mix_nonCM, ylim=c(0,0.01))
get_hist_thr(mix_CM, mix_nonCM, ylim=c(0,0.2))
dev.off()

#cagemate_vs_noncagemate_mix

?boxplot

boxplot(mix_CM, mix_nonCM)

# Create a data frame
data_W_1 <- data.frame(Value = c(mix_CM, mix_nonCM),
                   Object = factor(rep(c("mix_CM", "mix_nonCM"),
                                       times = c(length(mix_CM), length(mix_nonCM))))
)

data <- rbind(data_W_1, data_W_2)
shapiro.test(data$Value)

#data_W_2
#data_W_1



# Load the ggpubr package
library(ggplot2)
library(ggpubr)

my_comparisons <- list(c("mix_CM", "mix_nonCM"))

# Create the box plot
p <- ggboxplot(data, x = "Object", y = "Value", 
               ylab = "Proportion of contamination", xlab = "Cage mates VS non-cage mates",
               add = "jitter", add.params = list(size = 0.2, jitter = 0.2), color = "Object") +
  
  stat_compare_means(comparisons = my_comparisons)

# Show the plot
print(p)

###PLOTTING COUNTS

get_hist_thr2 <- function(mix_CM, mix_nonCM, thr=0, ylims=c(0,40)){
  high_mixCM = mix_CM[mix_CM > thr]
  high_mixnonCM = mix_nonCM[mix_nonCM > thr]
  fract_CM = length(high_mixCM) / length(mix_CM)
  fract_nonCM = length(high_mixnonCM) / length(mix_nonCM)
  
  mox_x = max(high_mixCM,high_mixnonCM)
  brokes = seq(0,mox_x+0.1, by = 0.015)
  #brokes = seq(0,mox_x+0.04, by = 0.002)
  # brokes = seq(0,mox_x+0.002, by = 0.002)
  # brokes = seq(0,mox_x+0.02, by = 0.02)
  #brokes = seq(0,mox_x+, by = 5)
  
  h1 = hist(high_mixCM, breaks = brokes, plot = FALSE)
  h2 = hist(high_mixnonCM, breaks = brokes, plot = FALSE)
  
  # h1 = hist(high_mixCM, plot = FALSE)
  # h2 = hist(high_mixnonCM, plot = FALSE)
  
  # ==> Getting the counts as proportional to the tot count number <==
  h1$counts <- h1$counts / sum(h1$counts)
  h2$counts <- h2$counts / sum(h2$counts)
  
  mox_y = max(c(h1$counts,h2$counts))
  #mox_y=max(h1$counts) 
  
  plot <- plot(h1, col = c1, xlim = c(0,mox_x), ylim = ylims, freq = FALSE,
               xlab = 'Proportion of contamination', ylab = 'Counts', las = 1)
  plot2 <- plot(h2, col = c2, add=T, xlim = c(0,mox_x), ylim = ylims, freq = FALSE,
                xlab = 'Proportion of contamination', ylab = 'Counts', las = 1)
  #hist(all_VCs$var_Ad, add = T, col = c2, freq = TRUE, breaks = brokes)
  legend <- legend('topright',legend = c('Cage mates','Non-cage mates'), fill = c(c1,c2), cex=1.1)
  #  l_pos <- c(legend$rect$left, legend$rect$top - legend$rect$h)
  #  sub_gen <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
  #                  labels="Plotted fraction:")
  #  sub_cm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c1_full,
  #                    labels=paste0(round(fract_CM,2)*100, " %"))
  #  sub_noncm <- text(l_pos[1], l_pos[2], adj = c(-1,5.5), col=c2_full,
  #                    labels=paste0(round(fract_nonCM,2)*100, " %"))
  
  #return(list(plot, plot2, legend, sub_cm, sub_noncm))
}
get_hist_thr2(mix_CM, mix_nonCM, ylim=c(0,10))
get_hist_thr2(mix_CM, mix_nonCM, ylim=c(0,50))
get_hist_thr2(mix_CM, mix_nonCM, ylim=c(0,20))
get_hist_thr2(mix_CM, mix_nonCM, ylim=c(0,320))
get_hist_thr2(mix_CM, mix_nonCM, ylim=c(0,150))

typeof(mix_CM)
class(mix_CM)

#### SEPARATE PLOTS
# same plots as above but separated
separate_hist <- function(mix_CM, mix_nonCM, thr=0, ylims=c(0,1)){
  high_mixCM = mix_CM[mix_CM > thr]
  high_mixnonCM = mix_nonCM[mix_nonCM > thr]
  fract_CM = length(high_mixCM) / length(mix_CM)
  fract_nonCM = length(high_mixnonCM) / length(mix_nonCM)
  
  mox_x = max(high_mixCM,high_mixnonCM)
  
  brokes = seq(0,mox_x+0.04, by = 0.002)
  #brokes = seq(0,mox_x+0.02, by = 0.02)
  #brokes = seq(0,mox_x+5, by = 5)
  
  h1 = hist(high_mixCM, breaks = brokes, plot = FALSE)
  h2 = hist(high_mixnonCM, breaks = brokes, plot = FALSE)
  
  # ==> Getting the counts as proportional to the tot count number <==
  h1$counts <- h1$counts / sum(h1$counts)
  h2$counts <- h2$counts / sum(h2$counts)
  
  mox_y = max(c(h1$counts,h2$counts))
  #mox_y=max(h1$counts) 
  
  p_cm <- plot(h1, col = c1, xlim = c(0,mox_x), ylim = ylims, freq = TRUE,
               xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1)
  l_cm <- legend('topright',legend = c('Cage mates'), fill = c(c1), cex=1.1)
#  l_pos <- c(l_cm$rect$left, l_cm$rect$top - l_cm$rect$h)
#  sub_gencm <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
#                    labels="Plotted fraction:")
#  sub_cm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c1_full,
#                 labels=paste0(round(fract_CM,2)*100, " %"))
  
  p_noncm <- plot(h2, col = c2, xlim = c(0,mox_x), ylim = ylims, freq = TRUE,
                  xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1)
  l_noncm <-  legend('topright',legend = c('Non-cage mates'), fill = c(c2), cex=1.1)
#  l_pos <- c(l_noncm$rect$left, l_noncm$rect$top - l_noncm$rect$h)
#  sub_gennon <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
#                     labels="Plotted fraction:")
#  sub_noncm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c2_full,
#                    labels=paste0(round(fract_nonCM,2)*100, " %"))
#  
#  #return(list(p_cm, l_cm,sub_gencm,sub_cm,  p_noncm, l_noncm, sub_gennon, sub_noncm))
}

pdf(paste0(plot_dir,'hist_mixtures_cm_noncm_v2','.pdf'))
separate_hist(mix_CM, mix_nonCM)
#separate_hist(mix_CM, mix_nonCM, ylim=c(0,0.05))
separate_hist(mix_CM, mix_nonCM, ylim=c(0,0.1))
dev.off()




#### COUNTS IN ARREARS.
#### SEPARATE PLOTS
# same plots as above but separated
separate_hist2 <- function(mix_CM, mix_nonCM, thr=0, ylims=c(0,1)){
  high_mixCM = mix_CM[mix_CM > thr]
  high_mixnonCM = mix_nonCM[mix_nonCM > thr]
  # fract_CM = length(high_mixCM) / length(mix_CM)
  # fract_nonCM = length(high_mixnonCM) / length(mix_nonCM)
  
  mox_x = max(high_mixCM,high_mixnonCM)
  
  brokes = seq(0,mox_x+0.1, by = 0.015)
  # brokes = seq(0,mox_x+0.04, by = 0.002)
  #brokes = seq(0,mox_x+0.02, by = 0.02)
  #brokes = seq(0,mox_x+5, by = 5)
  
  h1 = hist(high_mixCM, breaks = brokes, plot = FALSE)
  h2 = hist(high_mixnonCM, breaks = brokes, plot = FALSE)
  
  # ==> Getting the counts as proportional to the tot count number <==
  h1$counts <- h1$counts
  h2$counts <- h2$counts
  
  mox_y = max(c(h1$counts,h2$counts))
  #mox_y=max(h1$counts) 
  
  p_cm <- plot(h1, col = c1, xlim = c(0,mox_x), ylim = ylims, freq = FALSE,
               xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1)
  l_cm <- legend('topright',legend = c('Cage mates'), fill = c(c1), cex=1.1)
  #  l_pos <- c(l_cm$rect$left, l_cm$rect$top - l_cm$rect$h)
  #  sub_gencm <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
  #                    labels="Plotted fraction:")
  #  sub_cm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c1_full,
  #                 labels=paste0(round(fract_CM,2)*100, " %"))
  
  p_noncm <- plot(h2, col = c2, xlim = c(0,mox_x), ylim = ylims, freq = FALSE,
                  xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1)
  l_noncm <-  legend('topright',legend = c('Non-cage mates'), fill = c(c2), cex=1.1)
  #  l_pos <- c(l_noncm$rect$left, l_noncm$rect$top - l_noncm$rect$h)
  #  sub_gennon <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
  #                     labels="Plotted fraction:")
  #  sub_noncm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c2_full,
  #                    labels=paste0(round(fract_nonCM,2)*100, " %"))
  #  
  #  #return(list(p_cm, l_cm,sub_gencm,sub_cm,  p_noncm, l_noncm, sub_gennon, sub_noncm))
}

separate_hist2(mix_CM, mix_nonCM, ylim=c(0,10))
separate_hist2(mix_CM, mix_nonCM, ylim=c(0,50))
separate_hist2(mix_CM, mix_nonCM, ylim=c(0,20))
separate_hist2(mix_CM, mix_nonCM, ylim=c(0,320))



#separate_hist_thr <- function(mix_CM, mix_nonCM, thr =0){
#   high_mixCM = mix_CM[mix_CM > thr]
#   high_mixnonCM = mix_nonCM[mix_nonCM > thr]
#   fract_CM = length(high_mixCM) / length(mix_CM)
#   fract_nonCM = length(high_mixnonCM) / length(mix_nonCM)
#   
#   mox_x = max(high_mixCM,high_mixnonCM)
#   
#   brokes = seq(0,mox_x+0.02, by = 0.02)
#   #brokes = seq(0,mox_x+5, by = 5)
#   
#   h1 = hist(high_mixCM, breaks = brokes, plot = FALSE)
#   h2 = hist(high_mixnonCM, breaks = brokes, plot = FALSE)
#   
#   # ==> Getting the counts as proportional to the tot count number <==
#   h1$counts <- h1$counts / sum(h1$counts)
#   h2$counts <- h2$counts / sum(h2$counts)
#   
#   mox_y = max(c(h1$counts,h2$counts))
#   #mox_y=max(h1$counts) 
#  
#   p_cm <- plot(h1, col = c1, xlim = c(0,mox_x), ylim = c(0,mox_y), freq = TRUE,
#        xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1, 
#        main = paste0('Mixtures with prop of contamination > ', thr))
#   l_cm <- legend('topright',legend = c('Cage mates'), fill = c(c1))
#   l_pos <- c(l_cm$rect$left, l_cm$rect$top - l_cm$rect$h)
#   sub_gencm <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
#                   labels="Plotted fraction:")
#   sub_cm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c1_full,
#                  labels=paste0(round(fract_CM,2)*100, " %"))
#   
#   p_noncm <- plot(h2, col = c2, xlim = c(0,mox_x), ylim = c(0,mox_y), freq = TRUE,
#        xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1, 
#        main = paste0('Mixtures with prop of contamination > ', thr))
#   l_noncm <-  legend('topright',legend = c('Non-cage mates'), fill = c(c2))
#   l_pos <- c(l_noncm$rect$left, l_noncm$rect$top - l_noncm$rect$h)
#   sub_gennon <- text(l_pos[1], l_pos[2], adj = c(-0.05,2), col="black",
#                   labels="Plotted fraction:")
#   sub_noncm <- text(l_pos[1], l_pos[2], adj = c(-1,4), col=c2_full,
#                     labels=paste0(round(fract_nonCM,2)*100, " %"))
#   
#   #return(list(p_cm, l_cm,sub_gencm,sub_cm,  p_noncm, l_noncm, sub_gennon, sub_noncm))
# }

### Just some working stuff

#mox_x = max(mix_CM,mix_nonCM)
#
#brokes = seq(0,mox_x+0.01, by = 0.01)
#
#h1 = hist(mix_CM, breaks = brokes, plot = FALSE)
#h2 = hist(mix_nonCM, breaks = brokes, plot = FALSE)
#
## Getting the counts as proportional to the tot number
#h1$counts <- h1$counts / sum(h1$counts)
#h2$counts <- h2$counts / sum(h2$counts)
#
#mox_y = max(c(h1$counts,h2$counts))

#pdf('~/Desktop/cluster/P50/mixup/plot/cageEffects_Helene_v2.pdf')
#pdf('~/Desktop/cluster/P50/mixup/plot/cageEffects_Helene_v3.pdf')

#plot(h1, col = c1, xlim = c(0,mox_x), ylim = c(0,mox_y), freq = TRUE,
#     xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1, 
#     main = '')
#plot(h2, col = c2, add=T, xlim = c(0,mox_x), ylim = c(0,mox_y), freq = TRUE,
#     xlab = 'Proportion of contamination', ylab = 'Relative frequency', las = 1, 
#     main = '')
#legend('topright',legend = c('Cage mates','Non-cage mates'), fill = c(c1,c2))

#dev.off()
