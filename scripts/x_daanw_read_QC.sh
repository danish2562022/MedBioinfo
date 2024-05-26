#!/bin/bash
#SBATCH --account=naiss2024-22-540
#SBATCH --job-name=sample_query_and_fastq_dump
#SBATCH --output=job_output.log
#SBATCH --error=job_error.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=02:30:00

echo "Script start: download and initial sequencing read quality control"
date

# Load necessary modules (if applicable)
#module load singularity
#touch /proj/applied_bioinformatics/users/x_daanw/MedBioinfo/analyses/x_daanw_run_accessions.txt
# Execute SQLite3 query and save the output to a file

sqlite3 -csv -noheader -batch /proj/applied_bioinformatics/users/x_daanw/MedBioinfo/analyses/sample_collab.db "select TRIM(run_accession) from sample_annot spl left join sample2bioinformatician s2b using(patient_code) where username='x_daanw';" > /proj/applied_bioinformatics/users/x_daanw/MedBioinfo/analyses/x_daanw_run_accessions.txt

# Ensure the output directory exists
mkdir -p fastq_output

# Run fastq-dump using singularity
#cat x_daanw_run_accessions.txt | srun --cpus-per-task=8 singularity exec /proj/applied_bioinformatics/common_data/meta.sif xargs -a fastq-dump --split-files --gzip --outdir /proj/applied_bioinformatics/users/x_daanw/MedBioinfo/data/sra_fastq/

srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif xargs -a x_daanw_run_accessions.txt fastq-dump --split-files --gzip --outdir ./sra_fastq/
cp -r ./sra_fastq ../data/

echo "Script start: download and initial sequencing read quality control"


srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit -h
srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit stats -j 8 ./sra_fastq/*.fastq.gz

srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit rmdup -j 8 ./sra_fastq/*.fastq.gz

srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit locate -j 8 -p 'AGATCGGAAGAGCACACGTCTGAACTCCAGTCA' -p 'AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT'  ./sra_fastq/*.fastq.gz
srun --cpus-per-task=8 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif seqkit locate -j 8 -p 'AGATCGGAAG' -p 'AGATCGGAAG' -p 'GATCGGAAGA' -p 'GATCGGAAGA' ./sra_fastq/*.fastq.gz

srun --cpus-per-task=2 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif fastqc -t 2 --outdir=./fastqc "$fastq_dir/${accession}_1.fastq.gz" "$fastq_dir/${accession}_2.fastq.gz"


srun --cpus-per-task=2 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif xargs -I{} -a x_daanw_run_accessions.txt fastqc -t 2 --outdir=./fastqc "$fastq_dir/{}_1.fastq.gz" "$fastq_dir/{}_2.fastq.gz"

fastq_dir="./sra_fastq"
accession="ERR6913102"

srun --cpus-per-task=2 --time=02:30:00 singularity exec /proj/applied_bioinformatics/common_data/meta.sif xargs -I{} -a x_daanw_run_accessions.txt fastqc -t 2 --outdir=./fastqc "$fastq_dir/{}_1.fastq.gz" "$fastq_dir/{}_2.fastq.gz"


# scp x_daanw@tetralith.nsc.liu.se:/proj/applied_bioinformatics/users/x_daanw/MedBioinfo/scripts/fastqc/\*.html .
# Log the end of the script
echo "Script end"
date 
