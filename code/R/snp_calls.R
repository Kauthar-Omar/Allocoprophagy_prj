#### ARGUMENTS:
args = commandArgs(trailingOnly=TRUE)
snpcalls_dir=args[1]
#name corresponnding to the prefix of .bed, .bim and .fam files irrespective of chromosome.
prefix_name=args[2]

#Still have to figure out installing genio from the commandline to use command line arguments
# setwd("/users/abaud/komar/P50/allocoprophagy/output/genotypes/all_cecum_whole_genotypes/")
# snpcalls_dir <- "/users/abaud/komar/P50/allocoprophagy/output/genotypes/all_cecum_whole_genotypes/"
# prefix_name <- "hs_rats_n24_chr"

#Still have to figure out installing genio from the commandline to use command line arguments
setwd("/users/abaud/komar/P50/allocoprophagy/output/genotypes/32_rats/")
snpcalls_dir <- "/users/abaud/komar/P50/allocoprophagy/output/genotypes/32_rats/"
prefix_name <- "hs_rats_n32_chr"


#Install and load the package "genio"
#install.packages("genio")
library(genio)

#snpcalls_dir <- "/users/abaud/komar/P50/allocoprophagy/output/genotypes/cecum_whole_genotypes/"
#inserted as args[1]
for (chr in 1:20)
{
  bim <- read_bim(paste0(snpcalls_dir, prefix_name, chr, ".bim"))
  fam <- read_fam(paste0(snpcalls_dir, prefix_name, chr, ".fam"))
  imp_snps <- t(read_bed(paste0(snpcalls_dir, prefix_name, chr, ".bed"), bim$pos, fam$id))
  # Rename genotype IDs
  imp_snps[imp_snps==2] <-3 #BB as minor
  imp_snps[imp_snps==1] <-2 #AB 
  imp_snps[imp_snps==0] <-1 #AA as major
  snpinfo <- data.frame(chr=bim$chr,id=bim$id,pos=bim$pos,alleles=paste0(bim$ref, "|", bim$alt))
  snpinfo$alleles <- as.character(snpinfo$alleles)
  alleles <- strsplit(snpinfo$alleles, "\\|")
  snpinfo$allele1 <- sapply(alleles, "[", 1)
  snpinfo$allele2 <- sapply(alleles, "[", 2)
  snpinfo$gencol <- match(snpinfo$pos, colnames(imp_snps))
  #Save imp_snps and snpinfo in the same .RData file
  save(imp_snps, snpinfo, file=paste0(snpcalls_dir,"rdata/imp_snp_", chr, ".RData"))
}
