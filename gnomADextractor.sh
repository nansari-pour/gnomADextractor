#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=AF
#SBATCH --mem=10GB
#SBATCH --time=1:00:00
#SBATCH --output=AF_%j.outerr
#SBATCH --error=AF_%j.outerr

# SLURM-based pipeline for extracting gnomAD allele frequency (AF) for WGS/WES genomic variants

WORKDIR=$1
vcf_file=$2

# load the R module on the SLURM cluster - edit appropriately
module load R-cbrg/current

# make WORKDIR as the current working directory
cd $WORKDIR

# Run initial R script
Rscript R/gnomAD_input_from_vcf.R $vcf_file

# Submit job array to Slurm
job_array_id=$(sbatch -a 1-22 BASH/variant_searcher_array.sh $WORKDIR $vcf_file | awk '{print $4}')

echo $job_array_id

# Submit final R script as a dependent job on the SLURM cluster
sbatch --dependency=afterok:$job_array_id <<EOF
#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=collate
#SBATCH --mem=10GB
#SBATCH --time=1:00:00
#SBATCH --output=${WORKDIR}collate_%j.outerr
#SBATCH --error=${WORKDIR}collate_%j.outerr

# load the R module on the SLURM cluster - edit appropriately
module load R-cbrg/current
# Run the final R script to collate AF data across all autosomal chromosomes
Rscript R/gnomAD_output_collate.R $vcf_file
EOF
