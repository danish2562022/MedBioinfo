#!/bin/bash
#SBATCH --account=naiss2024-22-540
#SBATCH --job-name=sample_query_and_fastq_dump
#SBATCH --output=job_output.log
#SBATCH --error=job_error.log
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=8
#SBATCH --time=02:30:00


echo "Seqkit"
date
fastq_dir="./sra_fastq"
accession="ERR6913102"

srun --cpus-per-task=2 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif xargs -I{} -a x_daanw_run_accessions.txt fastqc -t 2 --outdir=./fastqc "$fastq_dir/{}_1.fastq.gz" "$fastq_dir/{}_2.fastq.gz"



echo "Script end"
date 