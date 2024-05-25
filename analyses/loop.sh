
#!/bin/bash

# Assuming the file name is x_daanw_run_accessions.txt
filename="run_accessions.txt"

# Loop through each line in the file
while IFS= read -r line; do
    trimmed_line=$(echo "$line" | awk '{$1=$1;print}')
    echo "$trimmed_line"    # Run the command using the line as an argument
    fastq-dump --split-files --gzip --defline-seq '@$ac.$si.$ri' --disable-multithreading -X 10 -O ./data/sra_fastq "$trimmed_line" 

done < "$filename"
