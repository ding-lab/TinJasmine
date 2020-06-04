
# Background

germline_variant_snakemake is clone of WenWei's Snakemake-style germline caller
https://github.com/ding-lab/germline_variant_snakemake

germlinewrapper, as used by Fernanda,
https://github.com/ding-lab/germlinewrapper

Be aware of past germline work here:
    /Users/mwyczalk/Projects/TinDaisy/germlinewrapper
This was an aborted attempt to re-process Song's GermlineWrapper in the same
way as SomaticWrapper from early 2018.

GATK_GermlineCaller starts as a copy of https://github.com/ding-lab/varscan_vcf_remap tag 20191228

# Current development

* GATK_GermlineCaller
    * complete
* Pindel_GermlineCaller
    * complete
* Varscan_GermlineCaller
    * complete
* varscan_vcf_remap
    * complete
* VLD_FilterVCF
    * complete
      * needs additional testing for -R option - retain filtered variants
* MergeFilterVCF
    * In development

## Side projects
* WUDocker is a general purpose start_docker implementation.  Use that instead of start_docker for every project
    https://github.com/ding-lab/WUDocker.git

## shiso:/Users/mwyczalk/Projects/GermlineCaller

Background research, early implementations

## Katmai:/home/mwyczalk_test/Projects/GermlineCaller

Leads development of scripts

## MGI:/gscuser/mwyczalk/projects/GermlineCaller

Development of VCFs based on C3L-00001
