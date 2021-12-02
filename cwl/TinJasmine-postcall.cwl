class: Workflow
cwlVersion: v1.0
id: tin_jasmine
doc: >-
  TinJasmine workflow which bypasses calling and preliminary filtering (varscan 
  remap and pindel filtering).  Workflow begins with bcftools normalize.  Based
  on TinJasmine.cwl from commit fc861bf (9/10/21)
label: TinJasmine-postcall
inputs:
  - id: reference
    type: File
  - id: gatk_filter_config
    type: File
  - id: pindel_filter_config
    type: File
  - id: varscan_filter_config
    type: File
  - id: ROI_BED
    type: File
  - id: vep_cache_gz
    type: File?
  - id: vep_cache_version
    type: string?
  - id: assembly
    type: string?
  - id: Canonical_BED
    type: File
  - id: sample_barcode
    type: string?
  - id: varscan_snp_vcf
    type: File
  - id: varscan_indel_vcf
    type: File
  - id: pindel_vcf
    type: File
  - id: gatk_snp_vcf
    type: File
  - id: gatk_indel_vcf
    type: File
outputs:
  - id: clean_VCF
    outputSource:
      canonical_filter/output
    type: File
  - id: allCall_VCF
    outputSource:
      vep_annotate/output_dat
    type: File
  - id: clean_MAF
    outputSource:
      vcf2maf/output
    type: File
steps:
  - id: vld_filter_gatk_snp
    in:
      - id: VCF
        source: bcftools_normalize_gatk_snp/output
      - id: config
        source: gatk_filter_config
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLD_FilterVCF.cwl
    label: VLD_Filter_GATK_SNP
  - id: vld_filter_gatk_indel
    in:
      - id: VCF
        source: bcftools_normalize_gatk_indel/output
      - id: config
        source: gatk_filter_config
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLD_FilterVCF.cwl
    label: VLD_Filter_GATK_indel
  - id: vld_filter_pindel
    in:
      - id: VCF
        source: bcftools_normalize_pindel/output
      - id: config
        source: pindel_filter_config
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLD_FilterVCF.cwl
    label: VLD_Filter_Pindel
  - id: vld_filter_varscan_snp
    in:
      - id: VCF
        source: bcftools_normalize_varscan_snp/output
      - id: config
        source: varscan_filter_config
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLD_FilterVCF.cwl
    label: VLD_Filter_varscan_snp
  - id: vld_filter_varscan_indel
    in:
      - id: VCF
        source: bcftools_normalize_varscan_indel/output
      - id: config
        source: varscan_filter_config
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLD_FilterVCF.cwl
    label: VLD_Filter_varscan_indel
  - id: merge_vcf
    in:
      - id: reference
        source: reference
      - id: gatk_indel
        source: vld_filter_gatk_indel/output
      - id: gatk_snv
        source: vld_filter_gatk_snp/output
      - id: pindel
        source: vld_filter_pindel/output
      - id: varscan_indel
        source: vld_filter_varscan_indel/output
      - id: varscan_snv
        source: vld_filter_varscan_snp/output
    out:
      - id: merged_vcf
    run: ../submodules/MergeFilterVCF/cwl/MergeVCF.cwl
    label: Merge_VCF
  - id: filter_vcf
    in:
      - id: input_vcf
        source: merge_vcf/merged_vcf
    out:
      - id: merged_vcf
    run: ../submodules/MergeFilterVCF/cwl/FilterVCF.cwl
    label: Merge_Filter_VCF
  - id: roi_filter
    in:
      - id: VCF_A
        source: filter_vcf/merged_vcf
      - id: BED
        source: ROI_BED
      - id: retain_all
        default: true
      - id: filter_name
        default: roi
    out:
      - id: output
    run: ../submodules/HotspotFilter/cwl/hotspotfilter.cwl
    label: ROI_Filter
  - id: vep_annotate
    in:
      - id: input_vcf
        source: roi_filter/output
      - id: reference_fasta
        source: reference
      - id: assembly
        source: assembly
      - id: vep_cache_version
        source: vep_cache_version
      - id: vep_cache_gz
        source: vep_cache_gz
    out:
      - id: output_dat
    run: ../submodules/VEP_annotate/cwl/vep_annotate.TinJasmine.cwl
    label: vep_annotate
  - id: canonical_filter
    in:
      - id: VCF_A
        source: vep_annotate/output_dat
      - id: BED
        source: Canonical_BED
      - id: keep_only_pass
        default: true
      - id: filter_name
        default: canonical
    out:
      - id: output
    run: ../submodules/HotspotFilter/cwl/hotspotfilter.cwl
    label: CanonicalFilter
  - id: vcf2maf
    in:
      - id: ref-fasta
        source: reference
      - id: assembly
        source: assembly
      - id: input-vcf
        source: canonical_filter/output
      - id: normal_barcode
        source: sample_barcode
    out:
      - id: output
    run: ../submodules/vcf2maf-CWL/cwl/vcf2maf.cwl
    label: vcf2maf
  - id: bcftools_normalize_pindel
    in:
      - id: vcf
        source: pindel_vcf
    out:
      - id: output
    run: ./bcftools_normalize.cwl
    label: bcftools_normalize_pindel
  - id: bcftools_normalize_varscan_indel
    in:
      - id: vcf
        source: varscan_indel_vcf
    out:
      - id: output
    run: ./bcftools_normalize.cwl
    label: bcftools_normalize_varscan_indel
  - id: bcftools_normalize_varscan_snp
    in:
      - id: vcf
        source: varscan_snp_vcf
    out:
      - id: output
    run: ./bcftools_normalize.cwl
    label: bcftools_normalize_varscan_snp
  - id: bcftools_normalize_gatk_snp
    in:
      - id: vcf
        source: gatk_snp_vcf
    out:
      - id: output
    run: ./bcftools_normalize.cwl
    label: bcftools_normalize_gatk_snp
  - id: bcftools_normalize_gatk_indel
    in:
      - id: vcf
        source: gatk_indel_vcf
    out:
      - id: output
    run: ./bcftools_normalize.cwl
    label: bcftools_normalize_gatk_indel
requirements:
  - class: ScatterFeatureRequirement
