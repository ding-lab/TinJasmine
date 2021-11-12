This is a template for running TinJasmine using [Cromwell](https://cromwell.readthedocs.io/en/stable/) on compute1 system at Wash U.
Scripts here based closely on equivalent [TinDaisy](https://github.com/ding-lab/TinDaisy) demonstration runs

The example will perform TinJasmine germline variant calling on CPTAC3 case C3L-00081

# Setup

## WORKFLOW_ROOT
Prior to running, be sure to update the Cromwell configuration to point to an appropirate work directory, which will
typically be different for each user.  As an example, for user `m.wyczalkowski`, the destination directory may be,
    WORKFLOW_ROOT="/scratch1/fs1/dinglab/m.wyczalkowski/cromwell-data"

Specifically,
* Create `$WORKFLOW_ROOT` if it does not exist
* `cp dat/cromwell-config-db.compute1.template.dat dat/cromwell-config-db.compute1.dat`
* Edit `dat/cromwell-config-db.compute1.dat` to replace all instances of the string WORKFLOW_ROOT with the 
  appropriate value

# Starting

TinJasmine run on WXS data typically takes several hours.  Because of this, recommend to run it within a tmux session,
but this is not necessary for initial testing (just making sure it runs)

* `tmux new -s TinJasmine`
* `bash 0_start_docker-compute1_cromwell.sh`
* `cd testing/cromwell-simple-compute1`
* `bash 1_run_cromwell_demo.sh`

This should start Cromwell and run the TinJasmine workflow on a single case.  