#!/bin/env bash

# Set the input directory and output file name
input_dir="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/mRatBN7.2/sorted"
output_file="/users/abaud/komar/P50/allocoprophagy/output/metagenomes/counts/unpaired_mapped_mRatBN7.2_read_counts.txt"


# Loop over all the BAM files in the input directory
for bam_file in "$input_dir"/*_unpaired.bam
do
    # Get the file name without the directory path or file extension
    sample_name=$(basename -s .bam "$bam_file")

    # Count the number of mapped reads in the file and save to output file
    mapped_read_count=$(samtools view -c -F 4 "$bam_file")
    echo "$sample_name,$mapped_read_count" >> "$output_file"
done

