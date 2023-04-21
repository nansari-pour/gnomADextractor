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
1) VCF file to be annotated with population allele frequency (AF) - *note: both chromosome notations are acceptable (i.e. chr1 vs 1)*
2) the gnomAD reference files per chromosome in hg38_gnomAD_AF_chrom/ subdir in the WORKDIR (large files; available upon request)

## How it works
There are three key steps in this pipeline
* Generate input files per chromosome from the VCF file: This is a space dilimited file with five columns of chromosome, start position, end position, reference allele and the alternate allele - this is implemented in ***gnomAD_input_from_vcf.R***
* Search for variants observed in each chromsome of the VCF file for gnomAD population allele frequency (AF) - this is executed by ***variant_searcher_array.sh*** using the SLURM parallelisation feature (-a) for fast implementation.
* Collate the chromosome-level output files from the variant search step into one genome-wide output file - this is implemented in ***gnomAD_output_collate.R***

## Usage
To run the pipeline, follow these steps:

#### 1. Clone the repository:

```
$ git clone https://github.com/nansari-pour/gnomADextractor
```

#### 2. Navigate to the directory containing the pipeline scripts - this is considered the working directory:

```
$ cd gnomADextractor
```
Then copy the reference files folder (hg38_gnomAD_AF_chrom/) to this directory
```
$ cp -r /path/to/hg38_gnomAD_AF_chrom/ .
```
The VCF file can be anywhere but full path to it must be provided as vcf_file in the pipeline (i.e. the only argument provided to the pipeline script; see below)

#### 3. Submit the pipeline job using the sbatch command:

```
$ sbatch gnomADextractor.sh /full/path/to/VCF_file.vcf
```
The pipeline script takes in one argument: full path to the VCF file

## Output file format

The output file will be in a tab-delimited text file, with the following columns (including header):

Chromosome (CHROM)

Position (POS)

Reference allele (REF)

Alternate allele (ALT)

Population allele frequency (AF): *Variants with value of NA are those absent in gnomAD (i.e. novel or rare variant)*

## Contact

If you have any questions or issues with the pipeline, please contact **naser.ansari-pour@omicsconsultancy.co.uk**


