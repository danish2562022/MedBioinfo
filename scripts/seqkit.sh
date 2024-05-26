#!/bin/bash
#SBATCH --account=naiss2024-22-540
#SBATCH --job-name=sample_query_and_fastq_dump
#SBATCH --output=job_output.log
#SBATCH --error=job_error.log
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --time=02:30:00


echo "Script start: download and initial sequencing read quality control"
date

srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit -h
srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit stats -j 8 ./sra_fastq/*.fastq.gz



echo "Script end"
date 