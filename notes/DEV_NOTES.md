Germline calling details:
Kuan paper: https://www.cell.com/cell/fulltext/S0092-8674(18)30363-5
See KuanEtAlGermline.md

# Varscan:
Germline calling: http://varscan.sourceforge.net/germline-calling.html
Arguments: http://varscan.sourceforge.net/using-varscan.html

TinDaisy: (somatic)
    SAMTOOLS_CMD="$SWpaths::samtools mpileup -q 1 -Q 13 -B -f $REF -b $bam_list "
    JAVA_CMD="java \$JAVA_OPTS -jar $SWpaths::varscan_jar somatic - $run_name $varscan_args --output-snp $snvout --output-indel $indelout"
    $SAMTOOLS_CMD | $JAVA_CMD # &> $log

germlinewrapper:
print VARSCAN "\${SAMTOOLS_DIR}/samtools mpileup -q 1 -Q 13 -B -f $h38_REF -b \${BAMLIST} | awk -v ncols=\$ncols \'NF==ncols\' | java \${JAVA_OPTS} -jar \${VARSCAN_DIR}/VarScan.jar mpileup2snp  -  --p-value  0.10   --min-coverage  3   --min-var-freq  0.08   --min-reads2  2   --min-avg-qual  15   --min-freq-for-hom  0.75   --strand-filter  1   --output-vcf  1   > \${outsnp}  2> \${logsnp}\n";
print VARSCAN "\${SAMTOOLS_DIR}/samtools mpileup -q 1 -Q 13 -B -f $h38_REF -b \${BAMLIST} | awk -v ncols=\$ncols \'NF==ncols\' | java \${JAVA_OPTS} -jar \${VARSCAN_DIR}/VarScan.jar mpileup2indel  -  --p-value  0.10   --min-coverage  3   --min-var-freq  0.20   --min-reads2  2   --min-avg-qual  15   --min-freq-for-hom  0.75   --strand-filter  1   --output-vcf  1   > \${outindel}  2> \${logindel}\n";

germline snakemake:
    shell: "samtools mpileup -q 1 -Q 13 -f {input.genome_fa} -r {params.chr} {input.bam} | varscan mpileup2snp - --min-coverage 3 --min-var-freq 0.10 --p-value 0.10 --strand-filter 1 --output-vcf 1 > {output} 2>{log}"
    shell: "samtools mpileup -q 1 -Q 13 -f {input.genome_fa} -r {params.chr} {input.bam} | varscan mpileup2indel - --min-coverage 3 --min-var-freq 0.10 --p-value 0.10 --strand-filter 1 --output-vcf 1 > {output} 2>{log}"
    <after this it merges>

# Pindel

Pindel runs take place in two steps:
* run pindel, possibly per-chromosome
  * use TinDaisy-Core run_pindel_parallel.sh as a model for how to do this
* parse pindel output
  * This is done using GenomeVIP tool pindel_filter.sh
    * There are various versions of this floating around
    * use the one which comes with TinDaisy-Core, which is v0.6 and has significant readability / debug improvements
      over that shipped with germline wrapper

## Kuan

-x 4 -I -B 0 -M 3

## germlinewrapper:

    print PINDEL "$pindel -T 4 -f $h38_REF -i \${CONFIG} -o \${myRUNDIR}"."/$sample_name"." -m 6 -w 1\n";


pindel.filter.pindel2vcf = $PINDEL_DIR/pindel2vcf
pindel.filter.variants_file = \${RUNDIR}/pindel/pindel.out.raw
pindel.filter.REF = $h38_REF
pindel.filter.date = 000000
pindel.filter.heterozyg_min_var_allele_freq = 0.2
pindel.filter.homozyg_min_var_allele_freq = 0.8
pindel.filter.mode = germline
pindel.filter.apply_filter = true
pindel.filter.germline.min_coverages = 10
pindel.filter.germline.min_var_allele_freq = 0.20
pindel.filter.germline.require_balanced_reads = true
pindel.filter.germline.remove_complex_indels = true
pindel.filter.germline.max_num_homopolymer_repeat_units = 6

## germline_snakemake:

```
pindel.filter.variants_file = /mnt/data/input/{params.bucket}/pindel/chr{params.chr}/{params.sample}.pindel.out.chr{params.chr}.raw
pindel.filter.REF = {params.ref_file}
pindel.filter.date = 000000
pindel.filter.heterozyg_min_var_allele_freq = 0.2
pindel.filter.homozyg_min_var_allele_freq = 0.8
pindel.filter.mode = germline
pindel.filter.apply_filter = true
pindel.filter.germline.min_coverages = 10
pindel.filter.germline.min_var_allele_freq = 0.20
pindel.filter.germline.require_balanced_reads = 'true'
pindel.filter.germline.remove_complex_indels = 'true'
pindel.filter.germline.max_num_homopolymer_repeat_units = 6")

extra="-x 4 -w 0.1 -B 0 -M 3 -J /home/germline_variant_snakemake/files/pindel-centromere-exclude.bed -c {ix}"
shell: "echo -e ""{params.bam}\t500\t{params.sample}"" > {params.prefix}.pindel_config.txt; pindel {params.extra} -T {threads} -f {input.ref} -i {params.prefix}.pindel_config.txt -o {params.prefix} -L {log}; cat {params.prefix}_D {params.prefix}_INV {params.prefix}_TD {params.prefix}_SI | grep ChrID > {output}"

```
## TinDaisy (somatic):

PINDEL_ARGS=" -T 4 -m 6 -w 1"

# Merging

Test data from Fernanda.  Germline calls for family data: /gscmnt/gc2737/ding/fernanda/Germline_MMY/FamilialMM/
Raw data: /gscmnt/gc2545/multiple_myeloma/FamilialMMY

