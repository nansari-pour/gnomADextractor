# Auxiliary function to decide whether the input_vcf is a gz file
decide_gz <- function(input_vcf) {
  is_gz <- FALSE
  if (grepl("\\.gz$", input_vcf)){
    is_gz <- TRUE
  }
  return(is_gz)
}

# Function to create SNV-based input files per chromosome from the VCF file

gnomAD_input_from_vcf=function(input_vcf,variant_filter){
  # Decide whether the input_vcf is a gz file
  if (decide_gz(input_vcf)){
    # Method to get number of lines to skip
    command <- paste0("zgrep '^##' ", input_vcf, " | wc -l")
    num_comments <- as.numeric(system(command, intern = TRUE))
  } else {
  # Method to get number of lines to skip
  command <- paste0("grep '^##' ", input_vcf, " | wc -l")
  num_comments <- as.numeric(system(command, intern = TRUE))
  }
  # read in vcf file using num_comments
  # fill TRUE and sep by tab to allow reading of annotated vcfs
  vcf=read.table(input_vcf,header=T,comment.char = "",skip = num_comments,stringsAsFactors=F,fill = TRUE,sep = "\t") 
  colnames(vcf)[1]="CHROM"
  vcf_filename=basename(input_vcf)
  ChrNot <- nchar(vcf[1,1])
  write.table(ChrNot,paste0(gsub(".vcf","",vcf_filename),"_chrom_notation_length.txt"),col.names=F,row.names=F,quote=F)
  if (ChrNot>3){
    print("chr chromosome notation")
    vcf$CHROM=gsub("chr","",vcf$CHROM)
  }
  # Keep variants which match the variant_filter FILTERS (at least one e.g. "PASS")
  vcf=vcf[which(!is.na(match(vcf$FILTER,variant_filter))),]
  vcf$var=paste0(vcf$REF,vcf$ALT)
  snv=vcf[which(nchar(vcf$var)==2 & !grepl("-",vcf$var)),]
  snv$var=NULL
  for (i in 1:22){
    snv_chr=snv[snv$CHROM==i,]
    write.table(snv_chr[,c("CHROM","POS","POS","REF","ALT")],paste0(gsub(".vcf","",vcf_filename),"_chr",i,"_gnomAD_input.txt"),col.names = F,row.names = F,quote = F,sep=" ")
    print(i)
  }
}

# extract the vcf file string and variant types in the FILTER column to be retained 
Args=commandArgs(TRUE)
vcf_path=toString(Args[1])
variant_filter_types=toString(Args[2])

# Run the function
gnomAD_input_from_vcf(input_vcf = vcf_path,
                     variant_filter = variant_filter_types)
