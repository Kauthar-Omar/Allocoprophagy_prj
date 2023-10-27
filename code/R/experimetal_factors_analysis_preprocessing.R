#Rdata file for 150 samples in the experiment
load('/users/abaud/fmorillo/P50/microbiome_deep/output/felix/step1/Meta/comp_tab.RData') #object name: comp_tab

metadata <- read.csv("/nfs/users/abaud/fmorillo/P50/microbiome_deep/data/primary/metadata/p50_deep_metadata.csv")

#to match metadata file with samples in comp_tab
matched=match(comp_tab$Sample,metadata$Lab_ID)
metadata=metadata[matched,]

#Prepare the comparison table
comp_tab_all_deep_new <- data.frame(Sample=comp_tab$Sample,Dissection_date=metadata$Dissection_date,Phenotyping_center=metadata$Phenotyping_center,Sex=metadata$Sex,Material=metadata$Material,Fasting_state=metadata$Fasted,Reads_Before_Trimming_Paired=metadata$Lib_depth,Host_Reads=comp_tab$Host_Reads,Proportion_Host_Reads=comp_tab$Proportion_Host_Reads)

#Saving comp_table
save(comp_tab_all_deep_new,file="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/comp_tab_all_deep_new.RData")

#some of the script were adapted from my previous code: /nfs/users/abaud/komar/P50/allocoprophagy/Allocoprophagy_prj/code/R/Dissection_date_vs_propotion_of_host_reads.R