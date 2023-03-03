class: Workflow
cwlVersion: v1.0
id: tin_jasmine_v1_4_vep100
doc: TinJasmine germline variant caller with VEP v100 annotation
label: TinJasmine 1.4 VEP 100
inputs:
  - id: bam
    type: File
  - id: reference
    type: File
  - id: pindel_config_template
    type: File
  - id: ROI_BED
    type: File
  - id: vep_cache_gz
    type: File?
  - id: Canonical_BED
    type: File
  - id: chrlist
    type: File?
    doc: List of chromsome regions common to all callers
  - id: centromere
    type: File?
  - id: samples
    type: string
outputs:
  - id: clean_VCF
    outputSource:
      canonical_filter/output
    type: File
  - id: clean_MAF
    outputSource:
      vcf2maf/output
    type: File
  - id: all_call_vcf
    outputSource:
      vep_annotate_tin_jasmine_v100/output_dat
    type: File
steps:
  - id: gatk_germline_caller
    in:
      - id: reference
        source: reference
      - id: bam
        source: stage_bam/output
      - id: chrlist
        source: chrlist
      - id: njobs
        default: 2
      - id: finalize
        default: true
      - id: compress_output
        default: true
    out:
      - id: snp_vcf
      - id: indel_vcf
    run: ../submodules/GATK_GermlineCaller/cwl/GATK_GermlineCaller.cwl
    label: GATK_GermlineCaller
  - id: pindel_germline_caller
    in:
      - id: reference
        source: reference
      - id: bam
        source: stage_bam/output
      - id: chrlist
        source: chrlist
      - id: njobs
        default: 6
      - id: confirm_success
        default: true
      - id: finalize
        default: true
      - id: centromere
        source: centromere
    out:
      - id: pindel_sifted
    run: ../submodules/Pindel_GermlineCaller/cwl/pindel_caller.cwl
    label: Pindel_GermlineCaller
  - id: pindel_filter
    in:
      - id: pindel_sifted
        source: pindel_germline_caller/pindel_sifted
      - id: reference
        source: reference
      - id: pindel_config_template
        source: pindel_config_template
      - id: compress_output
        default: true
    out:
      - id: indel_vcf
    run: ../submodules/Pindel_GermlineCaller/cwl/pindel_filter.cwl
    label: Pindel_Filter
  - id: varscan_germline_caller
    in:
      - id: reference
        source: reference
      - id: bam
        source: stage_bam/output
      - id: chrlist
        source: chrlist
      - id: njobs
        default: 2
      - id: compress_output
        default: true
      - id: finalize
        default: true
    out:
      - id: snp_vcf
      - id: indel_vcf
    run: ../submodules/Varscan_GermlineCaller/cwl/Varscan_GermlineCaller.cwl
    label: Varscan_GermlineCaller
  - id: varscan_vcf_remap_snp
    in:
      - id: input
        source: varscan_germline_caller/snp_vcf
      - id: germline
        default: true
    out:
      - id: remapped_VCF
    run: ../submodules/varscan_vcf_remap/cwl/varscan_vcf_remap.cwl
    label: varscan_vcf_remap_snp
  - id: varscan_vcf_remap_indel
    in:
      - id: input
        source: varscan_germline_caller/indel_vcf
      - id: germline
        default: true
    out:
      - id: remapped_VCF
    run: ../submodules/varscan_vcf_remap/cwl/varscan_vcf_remap.cwl
    label: varscan_vcf_remap_indel
  - id: merge_vcf
    in:
      - id: reference
        source: reference
      - id: gatk_indel
        source: vlda_gatk_indel/output
      - id: gatk_snv
        source: vlda_gatk_snp/output
      - id: pindel
        source: vlda_pindel/output
      - id: varscan_indel
        source: vlda_varscan_indel/output
      - id: varscan_snv
        source: vlda_varscan_snp/output
      - id: ref_remap
        default: true
    out:
      - id: merged_vcf
    run: ../submodules/MergeFilterVCF/cwl/MergeVCF_TinJasmine.cwl
    label: Merge_VCF
  - id: merge_filter_vcf
    in:
      - id: input_vcf
        source: bcftools_normalize_postmerge/output
    out:
      - id: merged_vcf
    run: ../submodules/MergeFilterVCF/cwl/FilterVCF_TinJasmine.cwl
    label: Merge_Filter_VCF
  - id: roi_filter
    in:
      - id: VCF_A
        source: merge_filter_vcf/merged_vcf
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
  - id: canonical_filter
    in:
      - id: VCF_A
        source: vep_annotate_tin_jasmine_v100/output_dat
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
        default: GRCh38
      - id: input-vcf
        source: canonical_filter/output
      - id: normal_barcode
        source: samples
    out:
      - id: output
    run: ../submodules/vcf2maf-CWL/cwl/vcf2maf.cwl
    label: vcf2maf
  - id: bcftools_normalize_pindel
    in:
      - id: vcf
        source: pindel_filter/indel_vcf
      - id: reference
        source: reference
      - id: output_type
        default: z
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_normalize.cwl
    label: bcftools_normalize_pindel
  - id: bcftools_normalize_varscan_indel
    in:
      - id: vcf
        source: varscan_vcf_remap_indel/remapped_VCF
      - id: reference
        source: reference
      - id: output_type
        default: z
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_normalize.cwl
    label: bcftools_normalize_varscan_indel
  - id: bcftools_normalize_varscan_snp
    in:
      - id: vcf
        source: varscan_vcf_remap_snp/remapped_VCF
      - id: reference
        source: reference
      - id: output_type
        default: z
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_normalize.cwl
    label: bcftools_normalize_varscan_snp
  - id: bcftools_normalize_gatk_snp
    in:
      - id: vcf
        source: gatk_germline_caller/snp_vcf
      - id: reference
        source: reference
      - id: output_type
        default: z
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_normalize.cwl
    label: bcftools_normalize_gatk_snp
  - id: bcftools_normalize_gatk_indel
    in:
      - id: vcf
        source: gatk_germline_caller/indel_vcf
      - id: reference
        source: reference
      - id: output_type
        default: z
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_normalize.cwl
    label: bcftools_normalize_gatk_indel
  - id: stage_bam
    in:
      - id: BAM
        source: bam
    out:
      - id: output
    run: ./stage_bam.cwl
    label: stage_bam
  - id: vlda_gatk_snp
    in:
      - id: VCF
        source: bcftools_remove_spanning_deletions_gatk_snp/output
      - id: variant_caller
        default: GATK
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLDA_Filter-germline.cwl
    label: VLDA_gatk_snp
  - id: vlda_gatk_indel
    in:
      - id: VCF
        source: bcftools_remove_spanning_deletions_gatk_indel/output
      - id: variant_caller
        default: GATK
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLDA_Filter-germline.cwl
    label: VLDA_gatk_indel
  - id: vlda_varscan_snp
    in:
      - id: VCF
        source: bcftools_reheader_varscan_snp/output
      - id: variant_caller
        default: varscan
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLDA_Filter-germline.cwl
    label: VLDA_varscan_snp
  - id: vlda_varscan_indel
    in:
      - id: VCF
        source: bcftools_reheader_varscan_indel/output
      - id: variant_caller
        default: varscan
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLDA_Filter-germline.cwl
    label: VLDA_varscan_indel
  - id: vlda_pindel
    in:
      - id: VCF
        source: bcftools_reheader_pindel/output
      - id: variant_caller
        default: pindel
    out:
      - id: output
    run: ../submodules/VLD_FilterVCF/cwl/VLDA_Filter-germline.cwl
    label: VLDA_pindel
  - id: vep_annotate_tin_jasmine_v100
    in:
      - id: input_vcf
        source: roi_filter/output
      - id: reference_fasta
        source: reference
      - id: vep_cache_gz
        source: vep_cache_gz
    out:
      - id: output_dat
    run: ../submodules/VEP_annotate/cwl/vep_annotate.TinJasmine.v100.cwl
    label: vep_annotate TinJasmine v100
  - id: bcftools_reheader_varscan_snp
    in:
      - id: vcf
        source: bcftools_normalize_varscan_snp/output
      - id: samples
        source: samples
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_reheader.cwl
    label: bcftools_reheader_varscan_snp
  - id: bcftools_reheader_gatk_snp
    in:
      - id: vcf
        source: bcftools_normalize_gatk_snp/output
      - id: samples
        source: samples
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_reheader.cwl
    label: bcftools_reheader_gatk_snp
  - id: bcftools_reheader_pindel
    in:
      - id: vcf
        source: bcftools_normalize_pindel/output
      - id: samples
        source: samples
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_reheader.cwl
    label: bcftools_reheader_pindel
  - id: bcftools_reheader_varscan_indel
    in:
      - id: vcf
        source: bcftools_normalize_varscan_indel/output
      - id: samples
        source: samples
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_reheader.cwl
    label: bcftools_reheader_varscan_indel
  - id: bcftools_reheader_gatk_indel
    in:
      - id: vcf
        source: bcftools_normalize_gatk_indel/output
      - id: samples
        source: samples
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_reheader.cwl
    label: bcftools_reheader_gatk_indel
  - id: bcftools_remove_spanning_deletions_gatk_indel
    in:
      - id: vcf
        source: bcftools_reheader_gatk_indel/output
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_remove_spanning_deletions.cwl
    label: bcftools_remove_spanning_deletions_gatk_indel
  - id: bcftools_remove_spanning_deletions_gatk_snp
    in:
      - id: vcf
        source: bcftools_reheader_gatk_snp/output
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_remove_spanning_deletions.cwl
    label: bcftools_remove_spanning_deletions_gatk_snp
  - id: bcftools_normalize_postmerge
    in:
      - id: vcf
        source: fix_mleac/output
      - id: reference
        source: reference
      - id: output_type
        default: v
    out:
      - id: output
    run: ../submodules/bcftools/cwl/bcftools_normalize.cwl
    label: bcftools_normalize_postmerge
  - id: fix_mleac
    in:
      - id: vcf
        source: merge_vcf/merged_vcf
    out:
      - id: output
    run: ../submodules/bcftools/cwl/fix_MLEAC.cwl
    label: fix_mleac
requirements:
  - class: SubworkflowFeatureRequirement
