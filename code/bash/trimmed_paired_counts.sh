#!/bin/bash

# Set the input directory and output file name
input_dir="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/trimming/paired"
output_file="/users/abaud/komar/P50/allocoprophagy/output/illum_all_meta/counts/paired_trimmed_counts.txt"

touch $output_file

# Loop over all the compressed FASTQ files in the input directory
for fastq_file in "$input_dir"/*.fq.gz
do
    # Get the file name without the directory path or file extension
    sample_name=$(basename -s .fq.gz "$fastq_file")

    # Count the number of reads in the decompressed file and save to output file
    read_count=$(zcat "$fastq_file" | echo $(( $(wc -l) / 4 )))
    echo "$sample_name,$read_count" >> "$output_file"
done

