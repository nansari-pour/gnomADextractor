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
There are three key steps in this pipeline:
* Generate input files per chromosome from the VCF file: This is a space dilimited file with five columns of chromosome, start position, end position, reference allele and the alternate allele - this is implemented in ***R/gnomAD_input_from_vcf.R***
* Search for variants observed in each chromsome of the VCF file for gnomAD population allele frequency (AF) - this is executed by ***BASH/variant_searcher_array.sh*** using the SLURM parallelisation feature (-a) for fast implementation.
* Collate the chromosome-level output files from the variant search step into one genome-wide output file - this is implemented in ***R/gnomAD_output_collate.R***

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
The VCF file can be anywhere but full path to it must be provided as vcf_file in the pipeline (i.e. the first argument provided to the pipeline script; see below)

#### 3. Submit the pipeline job using the sbatch command:

```
$ sbatch gnomADextractor.sh /full/path/to/VCF_file.vcf "filter1,filter2,filter3"
```
The pipeline script takes in two arguments: 

a) full path to the VCF file

b) The variant filter types in the FILTER column of the VCF file to be retained (at least one and comma-delimited for more than one) e.g. "PASS" or "PASS,germline_risk,somatic"

## Output file format

1) The main output file (*\*_gnomAD_output.txt*) will be in a tab-delimited text file format, with the following columns (including header):

Chromosome (CHROM)

Position (POS)

Reference allele (REF)

Alternate allele (ALT)

Population allele frequency (AF): *Variants with value of NA are those absent in gnomAD (i.e. novel or rare variant)*

2) An additional file (specifically required by the Tumour-only mode of the Battenberg copy number pipeline) will also be generated (*\*_chrom_notation_length.txt*), which contains a single numeric value:

The numeric value (either 1 or 4) represents the length of the chromosome notation in the VCF file (emanating from the respective BAM file).

## Note for TOBB users

Both output files should be copied or symlinked to your TOBB working directory where your BAM file is (to be read by the **getSNVrho** function in TOBB)

## Contact

If you have any questions or issues with the pipeline, please contact **naser@omicsconsultancy.co.uk**


