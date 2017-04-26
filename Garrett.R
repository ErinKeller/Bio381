### April Garrett Presentation
### 19 April 2017
### ELK

# Introduction
# when you call SNPs from genomic data -> .vcf file
# standard .vcf file has chromosome number, position, reference allele = 0, alternative allele = 1, samples
# OASV2 = ocean acidification 
# 16 samples, 4 treatments

# First need to download Bioconductor, which is an open source software that uses R programming language to analyze high-throughput genomic data.
source("https://bioconductor.org/biocLite.R") # rather than install.packages we use open source bioconductor as the source for the packages

# Installing SNPRelate  and gdsfmt from Bioconductor
biocLite("SNPRelate")
library(SNPRelate)
library(gdsfmt)

# Read in the VCF (Variant Call Format) file, a common file structure for single nucleotide polymorphism, or "SNP", data
OASV2rmdupvcf <- ("OASV2-rmdup-Bio381-filtered.recode.vcf") # do not need to read it in as a table

# Reformatting to GDS considering a 2-allele only model (standard)
snpgdsVCF2GDS(OASV2rmdupvcf, "OASV2gds", method="biallelic.only") 

# Ignore the warning above, it is just because it didn't like how I parsed out some of the SNP data because I didn't want to share all of my dataset and using the whole dataset takes longer to run. Not necessary for this example.

# Open the reformatted file and name it
OASV2gds <- snpgdsOpen("OASV2gds")

# Get a summary of the dataset
snpgdsSummary("OASV2gds")
# The total number of samples: 16 
# The total number of SNPs: 120128 
# SNP genotypes are stored in SNP-major mode (Sample X SNP).

# Note: in this case individuals = a pooled population
# Speed up computation by requesting multiple threads via the num.thread command
# Use autosome.only=FALSE to account for the fact that we are working with non-human organisms (so not 23 chromosomes)

pca <- snpgdsPCA(OASV2gds, autosome.only=FALSE, num.thread=4)

# Create a vector of population IDs for being able to identify via color coding in the plot
# NOTE: Need to make sure these IDs match the order as in the original vcf file
popcode <- c("D1_7.5", "D1_7.5", "D1_7.5", "D1_7.5", "D1_8.0", "D1_8.0", "D1_8.0", "D1_8.0", "D7_7.5", "D7_7.5", "D7_7.5", "D7_7.5", "D7_8.0", "D7_8.0", "D7_8.0", "D7_8.0")

# Getting strucutre of PCA, which provides info on the PCs
str(pca)

plot(pca$eigenvect[,1],pca$eigenvect[,2], main="PCA with quality filtered SNPs", cex.main=2, xlab="Principal Component axis 1", cex.lab=1.5, cex.axis=1.5, ylab="Principal Component axis 2", col=as.factor(popcode), pch=20, cex=3)
legend("bottomleft", cex=1.3, legend=levels(as.factor(popcode)), pch=20, col=1:nlevels(as.factor(popcode)))
# Red = DAy 1 control samples, natural genetic variation
# after selective pressure, treatments cluster and lose genetic diversity as expected

# Notice that the legend is in the way of some of the points. Can correct this by moving it:
plot(pca$eigenvect[,1],pca$eigenvect[,2], main="PCA with quality filtered SNPs #2", cex.main=2, xlab="Principal Component axis 1", cex.lab=1.3, cex.axis=1.5, ylab="Principal Component axis 2", col=as.factor(popcode), pch=20, cex=3)
legend("topleft", cex=1.3, legend=levels(as.factor(popcode)), pch=20, col=1:nlevels(as.factor(popcode)))

# This prunes any SNPs with an r^2 > 0.2 between adjacent SNPs
snpset <- snpgdsLDpruning(OASV2gds, autosome.only=FALSE, ld.threshold=0.2)
snpset.id <- unlist(snpset)

# Now we run PCA again on the pruned data with no LD and plot (user-defined LD threshold):
pca_noLD <- snpgdsPCA(OASV2gds, snp.id=snpset.id, autosome.only=FALSE, num.thread=4)

plot(pca_noLD$eigenvect[,1],-1*(pca_noLD$eigenvect[,2]), main="PCA with no SNPs in LD", xlab="Principal Component axis 1", cex.lab=1.5, cex.axis=1.5, ylab="Principal Component axis 2", col=as.factor(popcode), pch=20, cex=3)
legend("topleft", cex=1.3, legend=levels(as.factor(popcode)), pch=20, col=1:nlevels(as.factor(popcode)))

# Saving PDF of plot
pdf(file="OASV2 PCA with quality filtered SNPs.pdf", height=5, width=8)

plot(pca$eigenvect[,1],pca$eigenvect[,2], main="PCA with quality filtered SNPs #2", cex.main=2, xlab="Principal Component axis 1", cex.lab=1.3, cex.axis=1.5, ylab="Principal Component axis 2", col=as.factor(popcode), pch=20, cex=3)
legend("topleft", cex=1.3, legend=levels(as.factor(popcode)), pch=20, col=1:nlevels(as.factor(popcode)))

dev.off()