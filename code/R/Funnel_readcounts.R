#Open the databases
metadata <- read.csv("/nfs/users/abaud/fmorillo/P50/microbiome_deep/data/primary/metadata/p50_deep_metadata.csv")
#Paired_trimmed
paired_trimmed <- read.csv("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/paired_trimmed_counts.txt", header = F)
paired_trimmed$V1=sapply(strsplit(paired_trimmed$V1, "_"), "[",3)

library(dplyr)
#Unpaired_trimmed
unpaired_trimmed <- read.csv("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/unpaired_trimmed_counts.txt", header = F)
#Since R1 and R2 follow each other, I look for read 1 with pattern "_R1_" in the 1st column.
# I add the counts of R2 from the row below R1 in the column V1(at this point has all counts)
#I then assign the value of R2 to a variable R2 in the R1 row.
unpaired_trimmed$R2 <- ifelse(grepl("_R1_", unpaired_trimmed$V1), lead(unpaired_trimmed$V2), NA)
#I now remove all rows without R2 column i.e non combined rows.
unpaired_trimmed <- unpaired_trimmed[!is.na(unpaired_trimmed$R2), ]
#extracting lab id only
unpaired_trimmed$V1=sapply(strsplit(unpaired_trimmed$V1, "_"), "[",3)
#Renaming the columns
colnames(unpaired_trimmed) <- c("Sample", "R1_unpaired", "R2_unpaired")

#Paired_mapped mRatBN7.2
paired_mapped <- read.csv('/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/paired_mapped_mRatBN7.2_read_counts.txt', header = F)
paired_mapped$V1=sapply(strsplit(paired_mapped$V1, "_"), "[",3)

#Paired_mapped rn6
#paired_mapped <- read.csv('/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/paired_mapped_read_counts.txt', header = F)
#paired_mapped$V1=sapply(strsplit(paired_mapped$V1, "_"), "[",3)

#Unpaired_mapped mRatBN7.2
unpaired_mapped <- read.csv('/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/unpaired_mapped_mRatBN7.2_read_counts.txt', header = F)
unpaired_mapped$R2 <- ifelse(grepl("_R1_", unpaired_mapped$V1), lead(unpaired_mapped$V2), NA) #combining R1 and R2
unpaired_mapped <- unpaired_mapped[!is.na(unpaired_mapped$R2), ]
unpaired_mapped$V1=sapply(strsplit(unpaired_mapped$V1, "_"), "[",3)
colnames(unpaired_mapped) <- c("Sample", "R1_unpaired", "R2_unpaired")

#Unpaired_mapped rn6
#unpaired_mapped <- read.csv('/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/unpaired_mapped_read_counts.txt', header = F)
#unpaired_mapped$R2 <- ifelse(grepl("_R1_", unpaired_mapped$V1), lead(unpaired_mapped$V2), NA) #combining R1 and R2
#unpaired_mapped <- unpaired_mapped[!is.na(unpaired_mapped$R2), ]
#unpaired_mapped$V1=sapply(strsplit(unpaired_mapped$V1, "_"), "[",3)
#colnames(unpaired_mapped) <- c("Sample", "R1_unpaired", "R2_unpaired")

motch=match(paired_trimmed$V1,metadata$Lab_ID)
metadata=metadata[motch,]


motch=match(paired_mapped$V1,metadata$Lab_ID)
metadata=metadata[motch,]

motch=match(paired_mapped$V1,paired_trimmed$V1)
paired_trimmed=paired_trimmed[motch,]


#Prepare the comparison table only for paired rn6
comp_tab_paired <- data.frame(Sample=paired_trimmed$V1,Reads_Before_Trimming_Paired=(metadata$Lib_depth * 2),Reads_After_Trimming_Paired=(paired_trimmed$V2 * 2), Mapped_reads=paired_mapped$V2)


##Create ratios
###Trimmed
comp_tab_paired$Proportion_Remaining_Reads_After_Trimming <- 100*(comp_tab_paired$Reads_After_Trimming_Paired / comp_tab_paired$Reads_Before_Trimming_Paired)
###Non-host
#comp_tab_paired$Proportion_Non_Host_Reads_From_Paired_Trimmed <- 100*(comp_tab_paired$Non_Host_Reads / comp_tab_paired$Reads_After_Trimming_Paired)
###Mapped
comp_tab_paired$Proportion_of_Mapped <- 100*(comp_tab_paired$Mapped_reads / comp_tab_paired$Reads_After_Trimming_Paired)

summary(comp_tab_paired)

comp_tab_paired <- na.omit(comp_tab_paired)

save(comp_tab_paired,file="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/comp_tab_paired.RData")


#Prepare the comparison table for all samples
comp_tab <- data.frame(Sample=paired_trimmed$V1, Raw_Reads=(metadata$Lib_depth * 2), Trimmed_Paired=(paired_trimmed$V2 * 2),
                       Trimmed_Unpaired=(unpaired_trimmed$R1_unpaired + unpaired_trimmed$R2_unpaired), Mapped_Paired=paired_mapped$V2,
                       Mapped_Unpaired=(unpaired_mapped$R1_unpaired + unpaired_mapped$R2_unpaired))

#Creating combinations
comp_tab$Trimmed_Paired_and_Unpaired <- comp_tab$Trimmed_Paired + comp_tab$Trimmed_Unpaired

comp_tab$Mapped_Paired_and_Unpaired <- comp_tab$Mapped_Paired + comp_tab$Mapped_Unpaired

##Create ratios

###Trimmed
comp_tab$Proportion_Remaining_Reads_After_Trimming <- 100*(comp_tab$Trimmed_Paired_and_Unpaired / comp_tab$Raw_Reads)

###Trimmed_Paired
comp_tab$Proportion_of_Paired_After_Trimming <- 100*(comp_tab$Trimmed_Paired / comp_tab$Raw_Reads)

###Trimmed_Unpaired
comp_tab$Proportion_of_Unpaired_After_Trimming <- 100*(comp_tab$Trimmed_Unpaired / comp_tab$Raw_Reads)

###Mapped
comp_tab$Proportion_of_Mapped_Reads <- 100*(comp_tab$Mapped_Paired_and_Unpaired / comp_tab$Trimmed_Paired_and_Unpaired)

###Mapped_Paired
comp_tab$Proportion_of_Paired_Mapped_Reads <- 100*(comp_tab$Mapped_Paired / comp_tab$Trimmed_Paired)

###Mapped_Unpaired
comp_tab$Proportion_of_Unpaired_Mapped_Reads <- 100*(comp_tab$Mapped_Unpaired / comp_tab$Trimmed_Unpaired)

summary(comp_tab)

save(comp_tab,file="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/comp_tab.RData")
load("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/comp_tab.RData")

summary(comp_tab)
sum(comp_tab$Raw_Reads)
ORIG_METADATA <- read.csv("/nfs/users/abaud/fmorillo/P50/microbiome_deep/data/primary/metadata/p50_deep_metadata.csv")
