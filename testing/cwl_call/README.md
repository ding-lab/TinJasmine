# Setup
Currently using file-based cromwell database for one-off runs

## WORKFLOW_ROOT
Prior to running, be sure to update the template Cromwell configuration to point to an appropirate work directory, which will
typically be different for each user.  As an example, for user `m.wyczalkowski`, the destination directory may be,
    WORKFLOW_ROOT="/scratch1/fs1/dinglab/m.wyczalkowski/cromwell-data"

Specifically,
* Create `$WORKFLOW_ROOT` if it does not exist
    * Also create `$WORKFLOW_ROOT/logs`
* `cp dat/cromwell-config-db.compute1-filedb.template.dat dat/cromwell-config-db.compute1-filedb.dat`
* Edit `dat/cromwell-config-db.compute1-filedb.dat` to replace all instances of the string WORKFLOW_ROOT with the
  appropriate value

# Starting

Can run directly from command line and make sure terminal stays open.  This is the easiest and good for initial
testing
```
bash 0_start_docker-compute1_cromwell.sh
bash 1_run_cromwell_demo.sh
```

This can also be run in tmux session or submitted via bsub

## Results

TinJasmine.v1.2.vep-100.cwl.clean_VCF
/scratch1/fs1/dinglab/m.wyczalkowski/cromwell-data/cromwell-workdir/cromwell-executions/TinJasmine.v1.2.vep-100.cwl/d0259346-a53c-4392-bde7-412993548128/call-canonical_filter/execution/output/HotspotFiltered.vcf

TinJasmine.v1.2.vep-100.cwl.all_call_vcf
/scratch1/fs1/dinglab/m.wyczalkowski/cromwell-data/cromwell-workdir/cromwell-executions/TinJasmine.v1.2.vep-100.cwl/d0259346-a53c-4392-bde7-412993548128/call-vep_annotate_tin_jasmine_v100/execution/results/vep/output_vep.vcf

TinJasmine.v1.2.vep-100.cwl.clean_MAF
/scratch1/fs1/dinglab/m.wyczalkowski/cromwell-data/cromwell-workdir/cromwell-executions/TinJasmine.v1.2.vep-100.cwl/d0259346-a53c-4392-bde7-412993548128/call-vcf2maf/execution/result.maf
