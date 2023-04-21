#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=gnomAD
#SBATCH --mem=10GB
#SBATCH --time=2:00:00
#SBATCH --output=gnomAD_%j.outerr
#SBATCH --error=gnomAD_%j.outerr

# Get the chromosome number from the job array
Chr=$SLURM_ARRAY_TASK_ID

vcf_file=$1
vcf_filename=${vcf_file%.vcf}

# gnomAD searcher parallelised across chromosomes #

# set the file path and pattern to search - the reference file folder hg38_gnomAD_AF_chrom/ must be in the WORKDIR
file_path="hg38_gnomAD_AF_chrom/hg38_gnomAD_AF_chr${Chr}.txt"
pattern_file="${vcf_filename}_chr${Chr}_gnomAD_input.txt"
out_file="${vcf_filename}_chr${Chr}_gnomAD_output.txt"

# read the pattern file line by line using a while loop
while read -r pattern; do
  echo $pattern
  out=$(echo $(fgrep -m 1 "$pattern" $file_path))
  if [ -n "$out" ]; then
    # output to file
    echo $out >> $out_file
    else
    # output NA
    echo $(echo $pattern "NA") >> $out_file
  fi
done < "$pattern_file"
