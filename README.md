# TinJasmine

TinJasmine is a CWL implementation of a germline variant calling pipeline.  It
is modeled on the Huang et al. [Pathogenic Germline Variants in 10,389 Adult
Cancers](https://www.cell.com/cell/fulltext/S0092-8674(18)30363-5) 

![TinJasmine Workflow](doc/TinJasmine.wf1.6.png?raw=true "TinJasmine Workflow")

See [CromwellRunner](https://github.com/ding-lab/CromwellRunner.git) for
information about managing pipeline runs using Cromwell on LSF environments

## Versions

* v1.4 - Filtering updates
  * Removing spanning deletions (ALT=`*`) from GATK calls 
  * Add post-merge normalization step to split multiallelic variants
    which were re-combined in merge step
  * Filtering for MLEAF/MLEAC issue
  * Bcftools moved to separate submodule and updated to v1.10.2
* v1.3 - Incorporates bcftools reheader to make all VCF headers consistent
* v1.2 
  * VLD filter which has parameters passed via CWL 
  * Updated VEP annotation with options for v99, v100, and v102
v1.1 
  * Initial version of TinJasmine compatible with CromwellRunner

### Subprojects

The TinJasmine CWL workflow consists of number of smaller CWL tools which
are developed as independent projects:

* [`GATK_GermlineCaller`](https://github.com/ding-lab/GATK_GermlineCaller.git)
* [`Varscan_GermlineCaller`](https://github.com/ding-lab/Varscan_GermlineCaller.git)
* [`Pindel_GermlineCaller`](https://github.com/ding-lab/Pindel_GermlineCaller.git)
* [`varscan_vcf_remap`](https://github.com/ding-lab/varscan_vcf_remap.git)
* [`MergeFilterVCF`](https://github.com/ding-lab/MergeFilterVCF.git)
* [`TinDaisy-VEP`](https://github.com/ding-lab/TinDaisy-VEP.git)
* [`HotspotFilter`](https://github.com/ding-lab/HotspotFilter.git)
* [`VCF2MAF`](https://github.com/ding-lab/vcf2maf-CWL.git)
* [`VLD_Filter`](https://github.com/ding-lab/VLD_FilterVCF.git)
* [`bcftools`](https://github.com/mwyczalkowski/bcftools.git) 
  * Wrapper around bcftools 1.10.2 with related filter scripts


### Installation

All of the subprojects can be installed together with TinJasmine as,
```
git clone --recurse-submodules https://github.com/ding-lab/TinJasmine.git
```

### Staging of files
Copies are made of BAM files in the preliminary "staging" step.  This is done for performance reasons on
Cromwell so that individual copies of the BAM are not generated for each caller.  Tool for staging of files
is "borrowed" from [BICSEQ2.CWL](https://github.com/mwyczalkowski/BICSEQ2.CWL.git).

## Output 
Three output files are produced:
* `all_call_vcf`: Contains all pre-merge PASS variants.  Any filters applied after merge step 
  will add a value to FILTER field but variant will be retained
    * Filename: `output_vep.vcf`
* `clean_VC`: Contains only those variants which have FILTER value PASS after all post-merge filters applied
    * Filename: `HotspotFiltered.vcf`
* `clean_MAF`: MAF version of all variants found in clean VCF
    * Filename: `result.maf`

# Contact info

m.wyczalkowski@wustl.edu
