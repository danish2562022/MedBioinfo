#!/bin/bash
echo "script start: download and initial sequencing read quality control"
date
#!/bin/bash
#SBATCH --account=naiss2024-22-540
#SBATCH --job-name=sample_query_and_fastq_dump
#SBATCH --output=job_output.log
#SBATCH --error=job_error.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=02:30:00

# Load necessary modules (if applicable)
# module load sqlite3 singularity

# Execute SQLite3 query
sqlite3 -batch /proj/applied_bioinformatics/common_data/sample_collab.db <<EOF
SELECT * FROM sample_annot spl
LEFT JOIN sample2bioinformatician s2b USING(patient_code)
WHERE username='x_daanw';
EOF

# Run fastq-dump using singularity
srun --cpus-per-task=8 --time=00:30:00 singularity exec your_image.sif xargs -a your_username_run_accessions.txt fastq-dump --split-files --gzip --outdir fastq_output/

date
echo "script end."
