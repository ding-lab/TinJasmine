For TCGA sequence data downloaded from the GDC, we selected one germline sample
and up to one tumor sample per case according to the following procedure. Files
designated as TCGA MC3 BAMs were prioritized due to their harmonization. A
dockerized version of GenomeVIP (Mashl et al., 2017) was used to coordinate
germline variant calling in the guise of integrating multiple tools: Germline
SNVs were identified using Varscan (Koboldt et al., 2012) (version 2.3.8 with
default parameters, except where –min-var-freq 0.10,–p value 0.10,–min-coverage
3,–strand-filter 1) operating on a mpileup stream produced by SAMtools (version
1.2 with default parameters, except where -q 1 -Q 13) and GATK (McKenna et al.,
2010) (version 3.5, using its haplotype caller in single-sample mode with
duplicate and unmapped reads removed and retaining calls with a minimum quality
threshold of 10). Germline indels were identified using Varscan (version and
parameters as above) and GATK (version and parameters as above) in
single-sample mode. We also applied Pindel (Ye et al., 2009) (version 0.2.5b8
with default parameters, except where -x 4, -I, -B 0, and -M 3 and excluded
centromere regions (genome.ucsc.edu)) for indel prediction. For all analyses,
we used the GRCh37-lite reference and specified an insertion size of 500
whenever this information was not provided in the BAM header.

All resulting variants were limited to coding regions of full-length
transcripts obtained from Ensembl release 70 plus the additional two base pairs
flanking each exon that cover splice donor/acceptor sites. Single nucleotide
variants (SNVs) were based on the union of raw GATK and VarScan calls. We
required that indels were called by at least two out of the three callers
(GATK, Varscan, Pindel). In addition, we also included high-confidence,
Pindel-unique calls (at least 30x coverage and 20% VAF).

We then further required the variants to have an Allelic Depth (AD) ≥ 5 for the
alternative allele. A total of 49,123 variants passed these filters. We then
conducted readcount analyses for these variants in both normal and tumor
samples. We used bam-readcount (version 0.8.0 commit 1b9c52c, with parameters
-q 10, -b 15) to quantify the number of reference and alternative alleles. We
required the variants to have at least 5 counts of the alternative allele and
an alternative allele frequency of at least 20%, resulting in 31,963 variants.
Of these, we filtered for rare variants with ≤ 0.05% allele frequency in 1000
Genomes and ExAC (release r0.3.1).

