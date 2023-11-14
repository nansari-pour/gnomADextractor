# Function to collate gnomAD output files across all chromosomes

gnomAD_output_collate=function(vcf_file,chrom){
  vcf_id=ifelse(grepl("\\.gz$",vcf_file)==TRUE,gsub(".vcf.gz","",vcf_file),gsub(".vcf","",vcf_file))
  collate_output=data.frame()
  for (Chr in chrom){
    chr_output=read.table(paste0(vcf_id,"_chr",Chr,"_gnomAD_output.txt"),stringsAsFactors = F)
    collate_output=rbind(collate_output,chr_output)
    print(paste0("Chr",Chr))
  }
  names(collate_output)=c("CHROM","POS","pos","REF","ALT","AF")
  write.table(collate_output[,-3],paste0(vcf_id,"_gnomAD_output.txt"),col.names = T,row.names = F,quote = F,sep = "\t")
}

# Chromosomes to consider: autosomal chromosomes
chrom=1:22

# extract the vcf file string
Args=commandArgs(TRUE)
vcf_file=toString(Args[1])

# Run the function
gnomAD_output_collate(vcf_file=vcf_file,
                      chrom=1:22)
