# Past work

## TinDaisy Model Runs
Former TinDaisy runs: /gscuser/mwyczalk/projects/CromwellRunner/TinDaisy/8_CCRCC.HotspotProximity16.20200521/logs/stashed/074db967-d080-4ae5-a1e8-8e3f42e97412/C3N-00315.yaml


## Germline development with C3L-00001
Testing of germline CPTAC3 case C3L-00001 described here:
/gscuser/mwyczalk/projects/GermlineCaller/README.C3L-00001.md

### Pindel
/gscuser/mwyczalk/projects/GermlineCaller/old-modules/Pindel_GermlineCaller/testing/cwl_call/yaml/C3L-00001.yaml
```
bam:
  class: File
  path: /gscmnt/gc2619/dinglab_cptac3/GDC_import/data/a0e38199-402a-4ae1-b00d-ec9c67dd51df/1cc7a20f-b05e-4661-95ec-399b3080a02b_gdc_realn.bam
reference:
  class: File
  path: /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
chrlist:
  class: File
  path: /gscuser/mwyczalk/projects/TinDaisy/TinDaisy/params/chrlist/GRCh38.d1.vd1.chrlist.txt
finalize: true
```

### GATK

Run:
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/GATK_GermlineCaller.cwl/b5cc02af-9203-4ed7-952c-0df8e3b0b99d

testing/cwl_call/yaml/C3L-00001.yaml

Development:
https://github.com/ding-lab/GATK_GermlineCaller
    C3L-00001 branch 

YAML:
```
bam:
  class: File
  path: /gscmnt/gc2619/dinglab_cptac3/GDC_import/data/a0e38199-402a-4ae1-b00d-ec9c67dd51df/1cc7a20f-b05e-4661-95ec-399b3080a02b_gdc_realn.bam
reference:
  class: File
  path: /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
chrlist:
  class: File
  path: /gscuser/mwyczalk/projects/TinDaisy/TinDaisy/params/chrlist/GRCh38.d1.vd1.chrlist.txt
HC_ARGS: "--standard-min-confidence-threshold-for-calling 30.0"
finalize: true
```

### Varscan
/gscuser/mwyczalk/projects/GermlineCaller/old-modules/Varscan_GermlineCaller/testing/cwl_call/yaml/C3L-00001.yaml
```
bam:
  class: File
  path: /gscmnt/gc2619/dinglab_cptac3/GDC_import/data/a0e38199-402a-4ae1-b00d-ec9c67dd51df/1cc7a20f-b05e-4661-95ec-399b3080a02b_gdc_realn.bam
reference:
  class: File
  path: /gscmnt/gc2521/dinglab/mwyczalk/somatic-wrapper-data/image.data/A_Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
chrlist:
  class: File
  path: /gscuser/mwyczalk/projects/TinDaisy/TinDaisy/params/chrlist/GRCh38.d1.vd1.chrlist.txt
finalize: true
index_output: true
```

# New run
Will test LSCC WXS normal case C3L-00081:
C3L-00081.WXS.N.hg38    C3L-00081   LSCC    WXS blood_normal    /gscmnt/gc2619/dinglab_cptac3/GDC_import/data/ec948c00-910b-4c7b-82a7-4d209d377116/5e04faec-58e8-403f-942b-74e8c0053805_gdc_realn.bam   39312702311 BAM hg38    ec948c00-910b-4c7b-82a7-4d209d377116    MGI


# Key configurations

YAML file for this run: cwl_call/cwl-yaml/TinJasmine-C3L-00081.yaml

## BAM and Reference
reference:  /gscmnt/gc7202/dinglab/common/Reference/A_Reference/GRCh38.d1.vd1/GRCh38.d1.vd1.fa
bam: /gscmnt/gc2619/dinglab_cptac3/GDC_import/data/ec948c00-910b-4c7b-82a7-4d209d377116/5e04faec-58e8-403f-942b-74e8c0053805_gdc_realn.bam 


## CWL

Note that VEP annotate CWL has VEP arguments which are hardcoded and specific to TinJasmine, and different
from TinDaisy.  This may cause complications when this module is shared between the two workflows.

## ROI BED

From Fernanda:
/gscmnt/gc2737/ding/fernanda/Germline_MMY/FamilialMM/ReferenceFiles/BEDfiles/Homo_sapiens.GRCh38.95.allCDS.2bpFlanks.biomart.bed

## VEP v95

Will be installing VEP v95 cache to be compatible with Fernanda's workflow.
Describe how it was downloaded, make sure scripts available

For initial testing, will use VEP v99 which is already installed:

vep_cache_gz: /gscmnt/gc7202/dinglab/common/databases/VEP/v99/vep-cache.99_GRCh38.tar.gz
vep_cache_version: 99
assembly: GRCh38

## Config
These are in params distributed with VLD filter

varscan_filter_config:  /gscuser/mwyczalk/projects/GermlineCaller/TinJasmine/submodules/VLD_FilterVCF/params/VLD_FilterVCF-varscan.config.ini
pindel_filter_config:  /gscuser/mwyczalk/projects/GermlineCaller/TinJasmine/submodules/VLD_FilterVCF/params/VLD_FilterVCF-pindel.config.ini  
gatk_filter_config:  /gscuser/mwyczalk/projects/GermlineCaller/TinJasmine/submodules/VLD_FilterVCF/params/VLD_FilterVCF-GATK.config.ini


## Pindel Filter Config Template

This is distributed with Pindel Germline Caller params

pindel_config_template:  /gscuser/mwyczalk/projects/GermlineCaller/TinJasmine/submodules/Pindel_GermlineCaller/params/pindel_germline_filter_config.ini

Contents:
```
pindel.filter.heterozyg_min_var_allele_freq = 0.2
pindel.filter.homozyg_min_var_allele_freq = 0.8
pindel.filter.mode = germline
pindel.filter.apply_filter = true
pindel.filter.germline.min_coverages = 10
pindel.filter.germline.min_var_allele_freq = 0.20
pindel.filter.germline.require_balanced_reads = true
pindel.filter.germline.remove_complex_indels = true
pindel.filter.germline.max_num_homopolymer_repeat_units = 6
```

TODO: confirm that these are consistent with what is done for Germline and/or TinDaisy


## Other

canonical_BED:  gscuser/mwyczalk/projects/TinDaisy/TinDaisy/params/chrlist/GRCh38.callRegions.bed

### chrlist

All callers should have this, use same file

## Open questions

normal_barcode: 
  - and its cousin tumor_barcode.  Need to confirm that vcf2maf works right in the case of germline providing just one normal sample

reference:  # type "File"
    class: File
    path: a/file/path
bam:  # type "File"
    class: File
    path: a/file/path



