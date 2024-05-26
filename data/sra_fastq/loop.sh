for file in *.fastq.gz; do
    zcat "$file" > "${file%.gz}"
done
