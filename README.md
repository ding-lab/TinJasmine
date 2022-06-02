# TinJasmine

TinJasmine is a CWL implementation of a germline variant calling pipeline.  It
is modeled on the Huang et al. [Pathogenic Germline Variants in 10,389 Adult
Cancers](https://www.cell.com/cell/fulltext/S0092-8674(18)30363-5) 

![TinJasmine Workflow](doc/TinJasmine.wf1.4.png?raw=true "TinJasmine Workflow")

See [CromwellRunner](https://github.com/ding-lab/CromwellRunner.git) for
information about managing pipeline runs using Cromwell on LSF environments

## Versions

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


### Installation

All of the subprojects can be installed together with TinJasmine as,
```
git clone --recurse-submodules https://github.com/ding-lab/TinJasmine.git
```

### Staging of files
Copies are made of BAM files in the preliminary "staging" step.  This is done for performance reasons on
Cromwell so that individual copies of the BAM are not generated for each caller.  Tool for staging of files
is "borrowed" from [BICSEQ2.CWL](https://github.com/mwyczalkowski/BICSEQ2.CWL.git).

# Contact info

m.wyczalkowski@wustl.edu
