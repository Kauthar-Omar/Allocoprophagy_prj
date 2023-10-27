load("/nfs/users/abaud/data/primary/P50/metadata/metadata_augmented_16S_metabo.RData")

shallow_funnel <- read.csv("/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/funnel_shallow_data.csv")

summary(shallow_funnel)

processed_metadata <- metadata[1:37]

str(metadata)
processed_metadata$sample_name <-  row.names(processed_metadata)

# Split the names by "_" and select the first part
shallow_funnel$prefix <- sapply(strsplit(shallow_funnel$sample, '_'), "[", 1)

# View the modified data frame
shallow_funnel

matched=match(shallow_funnel$prefix,processed_metadata$sample_name)
processed_metadata=processed_metadata[matched,]

comp_tab_shallow <- data.frame(Sample=shallow_funnel$prefix,Dissection_date=processed_metadata$datetime_dissected,Proportion_Host_Reads=shallow_funnel$alignment_rate)


save(comp_tab_shallow,file="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/counts/comp_tab_date_vs_host_prop_shallow.RData")

