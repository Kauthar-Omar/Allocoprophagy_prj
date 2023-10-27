metadata <- read.csv("/nfs/users/abaud/fmorillo/P50/microbiome_deep/data/primary/metadata/p50_deep_metadata.csv")
paired_trimmed <- read.csv("/users/abaud/flisso/p50_felix/rat_deep/output/read_counts/trimmed_paired_counts/trimmed_paired_counts.txt")
paired_trimmed$run_prefix=sapply(strsplit(paired_trimmed$run_prefix, "_"), "[",3)
non_host <- read.csv("/users/abaud/flisso/p50_felix/rat_deep/output/read_counts/nohost_counts/nohost_counts.txt")
non_host$run_prefix=sapply(strsplit(non_host$run_prefix, "_"), "[",3)

motch=match(non_host$run_prefix,metadata$Lab_ID)
metadata=metadata[motch,]

#Prepare the comparison table
comp_tab_all_deep <- data.frame(Sample=paired_trimmed$run_prefix,Dissection_date=metadata$Dissection_date,Phenotyping_center=metadata$Phenotyping_center,Sex=metadata$Sex,Material=metadata$Material,Fasting_state=metadata$Fasted,Reads_Before_Trimming_Paired=metadata$Lib_depth,Reads_After_Trimming_Paired=paired_trimmed$trimmed_paired_numbers,Non_Host_Reads=non_host$nohost_numbers)

comp_tab_all_deep$Host_Reads <- (comp_tab_all_deep$Reads_After_Trimming_Paired - comp_tab_all_deep$Non_Host_Reads)

comp_tab_all_deep$Proportion_Host_Reads_From_Paired_Trimmed <- 100*(comp_tab_all_deep$Host_Reads / comp_tab_all_deep$Reads_After_Trimming_Paired)

comp_tab_all_deep$Proportion_Host_Reads_Paired_From_Sequenced_Reads <- 100*(comp_tab_all_deep$Host_Reads / comp_tab_all_deep$Reads_Before_Trimming_Paired)

#Saving comp_table
save(comp_tab_all_deep,file="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/counts/comp_tab_all_deep.RData")

metadata_orig <- read.csv("/nfs/users/abaud/fmorillo/P50/microbiome_deep/data/primary/metadata/p50_deep_metadata.csv")
