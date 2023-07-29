#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=AF
#SBATCH --mem=10GB
#SBATCH --time=1:00:00
#SBATCH --output=AF_%j.outerr
#SBATCH --error=AF_%j.outerr

# SLURM-based pipeline for extracting gnomAD allele frequency (AF) for WGS/WES genomic variants

vcf_path=$1
vcf_file=$(basename $vcf_path)

variant_filter_types=$2

# load the R module on the SLURM cluster - edit appropriately
module load R-cbrg/current

# Run initial R script
Rscript R/gnomAD_input_from_vcf.R $vcf_path $variant_filter_types

# Submit job array to Slurm
job_array_id=$(sbatch -a 1-22 BASH/variant_searcher_array.sh $vcf_file | awk '{print $4}')

echo $job_array_id

# Submit final R script as a dependent job on the SLURM cluster
sbatch --dependency=afterok:$job_array_id <<EOF
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=collate
#SBATCH --mem=10GB
#SBATCH --time=1:00:00
#SBATCH --output=collate_%j.outerr
#SBATCH --error=collate_%j.outerr

# load the R module on the SLURM cluster - edit appropriately
module load R-cbrg/current
# Run the final R script to collate AF data across all autosomal chromosomes
Rscript R/gnomAD_output_collate.R $vcf_file
EOF
