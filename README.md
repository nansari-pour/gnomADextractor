# gnomADextractor

This pipeline is designed to extract population allele frequency (AF) from gnomAD for WGS/WES genomic variants stored in a Variant Call Format (VCF) file. The pipeline is designed to employ the SLURM scheduler used in high-performance computing clusters.

## Prerequisites
Before running the pipeline, make sure you have the following dependencies installed:

R (version 3.0.2 or higher)
The pipeline assumes R is loaded on the cluster using:
```
$ module load R
```

## Input files
To run gnomADextractor you need:
1) VCF file to be annotated with population allele frequency (AF)
2) the gnomAD reference files per chromosome in hg38_gnomAD_AF_chrom/ subdir in the WORKDIR (large files; available upon request)

## How it works
There are three key steps in this pipeline
* Generate input files per chromosome from the VCF file: This is a space dilimited file with five columns of chromosome, start position, end position, reference allele and the alternate allele


## Usage
To run the pipeline, follow these steps:

Clone the repository:




