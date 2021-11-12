# TinJasmine

TinJasmine is a CWL implementation of a germline variant calling pipeline.  

It is modeled on the Huang et al. [Pathogenic Germline Variants in 10,389 Adult
Cancers](https://www.cell.com/cell/fulltext/S0092-8674(18)30363-5) See
KuanEtAlGermline.md for relevant method details.

![TinJasmine Workflow](notes/TinJasmine.v1.4.png?raw=true "TinJasmine Workflow")


## Past work

[`germline_variant_snakemake`](https://github.com/ding-lab/germline_variant_snakemake)
is Snakemake-based germline caller by Wen-Wei Liang

[`germlinewrapper`](https://github.com/ding-lab/germlinewrapper) was developed by Jay Mashl
and Song Cao, used by Fernanda Martins Rodrigues.

Be aware of past germline work on shiso (m.wyczalkowski laptop) here:
    /Users/mwyczalk/Projects/TinDaisy/germlinewrapper
This was an aborted attempt to re-process Song's GermlineWrapper in the same
way as SomaticWrapper from early 2018.

## Development Notes

Development work for TinJasmine (formerly GermlineCaller) have taken place here:
* shiso:/Users/mwyczalk/Projects/GermlineCaller
  * `DEV_NOTES.md` there has implementation details for caller scripts
* katmai:/home/mwyczalk_test/Projects/GermlineCaller
  * Initial development of callers takes place there
* compute1:/home/m.wyczalkowski/Projects/GermlineCaller/GermlineCaller
  * Development of compute1-based pipelines and testing with CromwellRunner
* MGI:/gscuser/mwyczalk/projects/GermlineCaller
  * Development of MGI-based pipelines and testing with real data

The overall structure of this project is based on the
[TinDaisy](https://github.com/ding-lab/TinDaisy.git) variant calling pipeline

See [CromwellRunner](https://github.com/ding-lab/CromwellRunner.git) for information about managing pipeline runs using
Cromwell on LSF environments

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


### Installation

All of the subprojects can be installed together with TinJasmine as,
```
git clone --recurse-submodules https://github.com/ding-lab/TinJasmine.git
```

Note that the principal dependencies are the CWL files associated with each subproject

### Staging of files
Copies are made of BAM files in the preliminary "staging" step.  This is done for performance reasons on
Cromwell so that individual copies of the BAM are not generated for each caller.  Tool for staging of files
is "borrowed" from [BICSEQ2.CWL](https://github.com/mwyczalkowski/BICSEQ2.CWL.git).

## Development

* can we put all C3L-00001 YAML files and basic run scripts here?
