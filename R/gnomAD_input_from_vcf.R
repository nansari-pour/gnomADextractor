# Function to create SNV-based input files per chromosome from the VCF file

gnomAD_input_from_vcf=function(input_vcf){
# Method to get number of lines to skip
command <- paste0("grep '^##' ", input_vcf, " | wc -l")
num_comments <- as.numeric(system(command, intern = TRUE))
# read in vcf file using num_comments
vcf=read.table(input_vcf,header=T,comment.char = "",skip = num_comments,stringsAsFactors=F)
colnames(vcf)[1]="CHROM"
vcf_filename=basename(input_vcf)
ChrNot <<- nchar(vcf[1,1])
if (ChrNot>3){
print("chr chromosome notation")
write.table(ChrNot,paste0(gsub(".vcf","",vcf_filename),"_chrom_notation_length.txt"),col.names=F,row.names=F,quote=F)
vcf$CHROM=gsub("chr","",vcf$CHROM)
}
vcf=vcf[which(vcf$FILTER=="PASS"),]
vcf$var=paste0(vcf$REF,vcf$ALT)
snv=vcf[which(nchar(vcf$var)==2 & !grepl("-",vcf$var)),]
snv$var=NULL
for (i in 1:22){
  snv_chr=snv[snv$CHROM==i,]
  write.table(snv_chr[,c("CHROM","POS","POS","REF","ALT")],paste0(gsub(".vcf","",vcf_filename),"_chr",i,"_gnomAD_input.txt"),col.names = F,row.names = F,quote = F,sep=" ")
  print(i)
}
}

# extract the vcf file string
Args=commandArgs(TRUE)
vcf_path=toString(Args[1])

# Run the function
gnomAD_input_from_vcf(input_vcf = vcf_path)
