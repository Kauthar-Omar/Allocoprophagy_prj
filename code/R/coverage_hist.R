# GETTING HIST FOR COVERAGE
library("ggthemes")
library("scales")


# Loading coverage from one sample
cov_dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/coverage"
plot_dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/coverage_plots/"
samples = list.dirs(path=cov_dir, recursive=F)

sample_names=sapply(strsplit(samples, "/"), "[", 11)

depth <- array(dim=length(unique(sample_names)),
               dimnames = list(sample_names))

for(i in seq_along(sample_names)){
  sample_oi <- sample_names[i]
  cov = read.delim(file.path(cov_dir, paste0(sample_oi,".cov")),
                   header=T)
  message("doing file ", file.path(cov_dir, paste0(sample_oi,".cov")))
  depth_oi <- mean(cov[cov[,1] %in% c(1:20),"meandepth"])
  depth[sample_oi] <- depth_oi
}
library("ggplot2")
library("ggpubr")
library(lineup2)

p <- gghistogram(depth, 
                 ylab = "    # cecal sample  (tot = 95)", 
                 xlab="average coverage of HOST genome (X)", fill="lightblue", 
                 bins=40
                 #add="mean", add.params = list(linetype="dashed", color="red")
) +
  #  annotate(label = paste0("mean = ", round(mean(depth),2)), x=round(mean(depth),2) +0.005), y=80 ) + 
  #scale_x_continuous(breaks = seq(0, 0.16, 0.02)) +
  #  bgcolor("gray90") +
  #  border("gray") +
  grids(linetype = "dashed", color="gray90", size=0.2)
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)))

p2 <- ggpar(p, font.y=c(14, "bold"), font.x=c(14,"bold"))
#ggpar(p, font.y=c(12,"bold"), font.x=c(12,"bold"))
dev.off()

ggsave(paste0(plot_dir,"average_cov_hosts_ALLsamples_hist.png"), p2, width=15, height = 15, unit ="cm", bg="transparent")

boxplot(depth)

library(ggpubr)

str(depth)

cov_bx <- ggboxplot(depth,
                    title = "Box plot showing mean depth distribution",
                    xlab = "Samples", ylab = "Coverage",
                    color = "#000080", add = c("mean","jitter"), #mean is a bigger dot that the others.(gives warning when mean added)
                    add.params = list(size = 0.1, jitter = 0.1),
                    label = sample_names,                # column containing point labels
                    label.select = list(top.up = 2),# Select some labels to display
                    font.label = list(size = 9, face = "italic"), # label font
                    repel = TRUE)
?desc_statby

cov_bx
# ggsave(plot_dir/"average_cov_hosts_ALLsamples_boxplot.png", plot = cov_bx, device = "png")
ggsave(paste0(plot_dir,"average_cov_hosts_ALLsamples_boxplot.png"), cov_bx, width=15, height = 15, unit ="cm", bg="transparent")

mean(depth)
# #creating another depth variable for all depths per chromosome
# #code still not working going to debug
# depth_final <- array(dim=c(length(unique(sample_names)),20),
#                dimnames = list(sample_names))
# 
# for(i in seq_along(sample_names)){
#   sample_all <- sample_names[i]
#   cov = read.delim(file.path(cov_dir, paste0(sample_all,".cov")),
#                    header=T)
#   message("doing file ", file.path(cov_dir, paste0(sample_all,".cov")))
#   depth_all <- array(cov[cov[,1] %in% c(1:20),"meandepth"])
#   depth_final[sample_all] <- depth_all
# }
# 
# depth_final <- array(dim=c(length(unique(sample_names)),20),
#                      dimnames = list(sample_names))
# str(depth_final)
