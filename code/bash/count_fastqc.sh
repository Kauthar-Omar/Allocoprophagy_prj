#!/bin/env bash

# Set the input directory and output file name
input_dir="/users/abaud/komar/P50/allocoprophagy/data/cecal"
output_file="/users/abaud/komar/P50/allocoprophagy/output/all_meta/counts/raw_read_counts.txt"

# Loop over all the compressed FASTQ files in the input directory
for fastq_file in "$input_dir"/*.fastq.gz
do
    # Get the file name without the directory path or file extension
    sample_name=$(basename "$fastq_file" .fastq.gz)

    # Count the number of reads in the decompressed file and save to output file
    read_count=$(zcat "$fastq_file" | echo $(( $(wc -l) / 4 )))
    echo "$sample_name: $read_count" >> "$output_file"
done

# Calculate the total read count and append to output file
total_read_count=$(cat "$output_file" | awk '{sum += $2} END {print sum}')
echo "Total: $total_read_count" >> "$output_file"
