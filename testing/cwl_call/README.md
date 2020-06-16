# Run 1
Dies at call-varscan_vcf_remap_snp
    /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/ea295a9b-2f90-4ae6-9971-656b9c366a36/call-varscan_vcf_remap_snp/execution/stderr


Looks like pindel_germline_caller may still be running?
$ bjobs -w
JOBID   USER    STAT  QUEUE      FROM_HOST   EXEC_HOST   JOB_NAME   SUBMIT_TIME
6978098 mwyczalk RUN   research-hpc blade17-3-8.gsc.wustl.edu blade17-4-11.gsc.wustl.edu cromwell_18482ffc_pindel_germline_caller Jun  9 03:00

-> this may be from an older run, because call-pindel_germline_caller seems to have a `rc` with value 0 and pindel_sifted.out exists


## varscan_vcf_remap error

Running: /usr/local/bin/python /opt/varscan_vcf_remap/src/varscan_vcf_remap.py --input --output /cromwell-executions/TinJasmine.cwl/ea295a9b-2f90-4ae6-9971-656b9c366a36/call-varscan_vcf_remap_snp/inputs/1718020027/Varscan.snp.Final.vcf.gz --germline --output varscan-remapped.vcf
usage: varscan_vcf_remap.py [-h] [-d] [-i INFN] [-o OUTFN] [-w] [-G]
varscan_vcf_remap.py: error: argument -i/--input: expected one argument

-> note that --output appears twice

This is probably a problem in run_varscan_vcf_remap.sh, where the python command is constructed.
What is the call to run_varscan_vcf_remap.sh?

Actual call is 
'/bin/bash' '/opt/varscan_vcf_remap/src/run_varscan_vcf_remap.sh' '--output' 'varscan-remapped.vcf' '/cromwell-executions/TinJasmine.cwl/ea295a9b-2f90-4ae6-9971-656b9c366a36/call-varscan_vcf_remap_indel/inputs/1718020027/Varscan.indel.Final.vcf.gz' '--germline'

What is the output of run_varscan?  Is it reporting back weird value?

-> seems that the CWL was messed up.  Updating the script

For testing of germline, use
    /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/ea295a9b-2f90-4ae6-9971-656b9c366a36/call-_varscan__germline_caller/execution/output/Varscan.snp.Final.vcf.gz
    /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/ea295a9b-2f90-4ae6-9971-656b9c366a36/call-_varscan__germline_caller/execution/output/Varscan.indel.Final.vcf.gz

## Timing details

GATK and varscan both have njobs = 4, took about 1 hr to run
Pindel has njobs = 5, took about 11 hrs to run

-> decrease GATK and varscan to njobs=2, increase pindel to njobs = 12

# Run 2

Pindel appears to be having memory issues.  STDERR of the job from /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_germline_caller/execution/stderr
```
[ Wed Jun 10 20:06:58 UTC 2020 ] Running: /usr/local/pindel/pindel -f /cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_germline_caller/inputs/-365693757/GRCh38.d1.vd1.fa -i ./output/raw/pindel_config.chr3.dat -o ./output/raw/pindel_chr3 -x 4 -I -B 0 -M 3 -c chr3 -J /cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_germline_caller/inputs/207482749/ucsc-centromere.GRCh38.bed
/opt/Pindel_GermlineCaller/src/utils.sh: line 41:   259 Killed                  /usr/local/pindel/pindel -f /cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_germline_caller/inputs/-365693757/GRCh38.d1.vd1.fa -i ./output/raw/pindel_config.chr3.dat -o ./output/raw/pindel_chr3 -x 4 -I -B 0 -M 3 -c chr3 -J /cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_germline_caller/inputs/207482749/ucsc-centromere.GRCh38.bed
[ Wed Jun 10 20:07:51 UTC 2020 ] pindel_caller.process_sample.sh Fatal ERROR. Exiting.
[ Wed Jun 10 20:07:51 UTC 2020 ] Completed successfully
```

Note that the job exits, but the outside loop seems to think it completed successfully (though it is hard to tell since this is multi-threaded; each job should have its own name)

## Error in pindel_filter
[2020-06-10 22:21:03,68] [info] WorkflowManagerActor Workflow 43e5d709-d9dc-41ab-b91d-ae7c3f89217d failed (during ExecutingWorkflowState): java.io.FileNotFoundException: Could no
t process output, file not found: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_filter/execu
tion/filtered/pindel_sifted.out.CvgVafStrand_pass.Homopolymer_pass.vcf

-> so it appears that call_pindel ran into problems, did not report error, but pindel_filter died.  

### Additional errors / details

From /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_filter/execution/stderr:

It seems there is an error in script:
    /opt/Pindel_GermlineCaller/src/pindel_filter.process_sample.sh: line 134: [: missing `]'

Also, note that output is compressed:
Running: /usr/local/bin/bgzip filtered/pindel_sifted.out.CvgVafStrand_pass.Homopolymer_pass.vcf && /usr/local/bcftools/bcftools index filtered/pindel_sifted.out.CvgVafStrand_pass.Homopolymer_pass.vcf.gz && rm -f filtered/pindel_sifted.out.CvgVafStrand_pass.Homopolymer_pass.vcf

-> so the fatal error we're getting is a consequence of a compress step in pindel_filter

## Error fixes

* deal with pindel_filter.process_sample.sh syntax and test it
    * may be just as simple as adding whitespace.  This is fixed, needs to be tested.
* Confirm whether we expect output to be compressed.  If so, adjust CWL so it exists
    do_index / compress_output should be false.  This is set in TinJasmine.cwl and should be fixed there
    alternatively, change cwl to match output name
* implement test of pindel_call to confirm that all chrom we expect to see are there.  This will catch memory problems

Need to test whether call_pindel completed successfully by testing whether all expected chrom exist in output

### Example data:

#### Success
Using run1 as an example:
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/ea295a9b-2f90-4ae6-9971-656b9c366a36/call-pindel_germline_caller/execution/output/pindel_sifted.out

#### Failure
Using run2 as an example:

/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/43e5d709-d9dc-41ab-b91d-ae7c3f89217d/call-pindel_germline_caller/execution/output/pindel_sifted.out

### Testing and implementing evaluate_success

evaluate_success implemented in mwyczalkowski/pindel_germlinecaller:20200612
This flag is on by default in TinJasmine
Test consists of making sure that all chromosomes in chrlist are represented at least once in the pindel output file, pindel_sifted.out
This will presumably catch any runs which exit incorrectly with success in cases where uncaught memory errors lead to chromosomes being skipped
This test can be igored by either turning it off entirely or passing warn_only, which prevents an exit if test fails

# Run 3

Run with evaluate_success on. Will revise pindel njobs = 6

Things to check:
* are all cromwell logs being retained?
  -> yes, seems so here: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/logs

## Pindel errors
Looking at log output an hour into run,
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-pindel_germline_caller/execution/stderr

Find error:
/opt/Pindel_GermlineCaller/src/utils.sh: line 41:   252 Killed                  /usr/local/pindel/pindel -f /cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-pindel_germline_caller/inputs/-365693757/GRCh38.d1.vd1.fa -i ./output/raw/pindel_config.chr4.dat -o ./output/raw/pindel_chr4 -x 4 -I -B 0 -M 3 -c chr4 -J /cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-pindel_germline_caller/inputs/207482749/ucsc-centromere.GRCh38.bed
[ Fri Jun 12 20:12:09 UTC 2020 ] pindel_caller.process_sample.sh Fatal ERROR. Exiting.

-> this is now a test to make sure that jobs quit appropriately
-> idea - change chrlist around so that the number of bases averaged over N jobs is roughly the same
   - thinking being that memory intensity of a job is proportional to length of chrom
   - if process chrX and chr1 at the same time, less likely to get memory error than if chr1 and chr2

## Additional errors

First, it seems that pindel caller erroneously succeeds:
[2020-06-13 02:40:11,45] [info] DispatchedConfigAsyncJobExecutionActor [3ce6f643pindel_germline_caller:NA:1]: Status change from Running to Done

Also, merge_vcf fails with,

[2020-06-13 02:53:41,85] [info] WorkflowManagerActor Workflow 3ce6f643-85f7-493a-8734-ed3cab36758f failed (during ExecutingWorkflowState): Job merge_vcf:NA:1 exited with return code 1 which has not been
declared as a valid return code. See 'continueOnReturnCode' runtime attribute for more details.
Check the content of stderr for potential additional information: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-merge_vcf/ex
ecution/stderr.

### What's up with pindel succeeding
chr4 does in fact have results in pindel_sifted.chrom.txt, as do all chromosomes, even though log file indicates errors.  Here are the chromsomes which failed:
    chr4 chr6 chr8 chr1 chr7 chr11 chr16

-> So our evaluate_success does not work.  We actually need to either catch the error or evaluate the stderr to see this
Maybe we want this argument to parallel (see https://www.gnu.org/software/parallel/man.html)
    --halt now,fail=1
    exit when the first job fails. Kill running jobs.
-> Test this with a large number of jobs so they fail quickly, pindel tool only

Turns out parallel doesn't recognise abnormal death by signal, so this will not work.  Instead, pindel caller writes a success
file when it completes; if the file is missing it indicates that it died badly

### Merge failing

Merge log file /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-merge_vcf/execution/stderr
has the following error,
    Invalid command line: No tribble type was provided on the command line and the type of the file '/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-merge_vcf/inputs/-1227464547/filtered.VLD_FilterVCF_output.vcf' could not be determined dynamically.

The following files, output form VLD Filter, are malformed, with just the header and no contents:
* call-vld_filter_gatk_indel/execution/VLD_FilterVCF_output.vcf
* call-vld_filter_gatk_snp/execution/VLD_FilterVCF_output.vcf
* call-vld_filter_pindel/execution/VLD_FilterVCF_output.vcf

-> this looks related to a pre-filter on these samples which changes sample name to "SAMPLE" using awk, but this fails for vcf.gz files

TODO: modify VLD_FilterVCF/src/run_vaf_length_depth_filters.sh so that it runs `zcat` on any compressed VCFs.
* Test this in a variety of settings
  * with VCF and VCF.GZ
  * with, without sample name remapping
  * with, without pipes

#### Test data
* GATK indel GZ: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-gatk_germline_caller/execution/output/GATK.indel.Final.vcf.gz
* pindel GZ: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-pindel_filter/execution/filtered/pindel_sifted.out.CvgVafStrand_pass.Homopolymer_pass.vcf.gz
* varscan indel VCF: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/3ce6f643-85f7-493a-8734-ed3cab36758f/call-varscan_vcf_remap_indel/execution/varscan-remapped.vcf  

-> copying these to katmai:/home/mwyczalk_test/Projects/GermlineCaller/C3L-00081 for testing

# Run 4

Testing updated VLD filter and pindel caller which uses success files to make sure all jobs complete OK.
Will retain NJOBS=6, but use a re-ordered chrlist file here:
    /gscuser/mwyczalk/projects/GermlineCaller/TinJasmine/submodules/Pindel_GermlineCaller/testing/cwl_call-MGI/cwl-yaml/GRCh38.d1.vd1.chrlist-reordered.txt

* hopefully this will reduce peak memory use

Still getting out of memory errors for pindel, njobs = 6 and memory = 28G:

/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/b6bc2338-dc9c-4303-b3dc-0ef397c8aea0/call-pindel_germline_caller/execution

TODO: confirm that this will die because success file not present

Yes, see /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/b6bc2338-dc9c-4303-b3dc-0ef397c8aea0/call-pindel_germline_caller/execution/stderr

# Run 5

Increase memory to 32G and keep njobs = 6
-> Running in /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9

-> seems like it succeeds!
{
  "outputs": {
    "TinJasmine.cwl.clean_VCF": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-canonical_filter/execution/output/HotspotFiltered.vcf",
      "size": 157776,
    },
    "TinJasmine.cwl.allCall_VCF": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-vep_annotate/execution/results/vep/output_vep.vcf",
      "size": 157429,
    },
    "TinJasmine.cwl.clean_MAF": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-vcf2maf/execution/result.maf",
      "size": 1620,
    }
  },
  "id": "739158e3-c905-4484-a2d8-dde3439c28d9"
}

-> However, the VCFs and MAFs are empty

Evaluate:
* timing
* format of VCF, check for any obvious errors

## Timing

### GATK
[2020-06-15 21:38:48,71] [info] DispatchedConfigAsyncJobExecutionActor [739158e3gatk_germline_caller:NA:1]: Status change from - to Running
[2020-06-15 23:43:27,94] [info] DispatchedConfigAsyncJobExecutionActor [739158e3gatk_germline_caller:NA:1]: Status change from Running to Done

-> eyeballing - 3 hrs 5 min

### Varscan
[2020-06-15 21:40:18,70] [info] DispatchedConfigAsyncJobExecutionActor [739158e3varscan_germline_caller:NA:1]: Status change from - to Running
[2020-06-15 22:53:54,89] [info] DispatchedConfigAsyncJobExecutionActor [739158e3varscan_germline_caller:NA:1]: Status change from Running to Done

-> eyeball - 1 hr 13 min

### Pindel
[2020-06-15 21:40:18,70] [info] DispatchedConfigAsyncJobExecutionActor [739158e3pindel_germline_caller:NA:1]: Status change from - to Runnin
[2020-06-16 05:39:20,44] [info] DispatchedConfigAsyncJobExecutionActor [739158e3pindel_germline_caller:NA:1]: Status change from Running to Done

-> eyeball - 8 hrs
-> this is unfortunate.  Will require additional development and tuning.  For now, acceptable

## Why are VCFs empty?

-> excluded at HotspotFilter / ROI filter
  * input VCF ok
stderr:
```
Running: mkdir -p output
Processing VCF_A = /cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-roi_filter/inputs/1204263469/filtered.vcf
BED = /cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-roi_filter/inputs/-1541611278/Homo_sapiens.GRCh38.95.allCDS.2bpFlanks.biomart.bed
VCF_B not provided
Running /opt/conda/bin/bedtools intersect -a /cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-roi_filter/inputs/1204263469/filtered.vcf -b /cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-roi_filter/inputs/-1541611278/Homo_sapiens.GRCh38.95.allCDS.2bpFlanks.biomart.bed >> output/HotspotFiltered.vcf
***** WARNING: File /cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-roi_filter/inputs/1204263469/filtered.vcf has inconsistent naming convention for record:
chr1    13273   .   G   C   1298.6  PASS    AC=1;AF=0.5;AN=2;DP=235;set=gatk_snv-varscan_snv    GT:AD:DP:GQ:PL  0/1:167,68:235:99:1306,0,4237

***** WARNING: File /cromwell-executions/TinJasmine.cwl/739158e3-c905-4484-a2d8-dde3439c28d9/call-roi_filter/inputs/1204263469/filtered.vcf has inconsistent naming convention for record:
chr1    13273   .   G   C   1298.6  PASS    AC=1;AF=0.5;AN=2;DP=235;set=gatk_snv-varscan_snv    GT:AD:DP:GQ:PL  0/1:167,68:235:99:1306,0,4237

Written to output/HotspotFiltered.vcf
```

### Testing HotspotFilter with actual data

CROMWELL_ROOT = /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions
Test with the above mapped as in real execution to run tests directly: 

chr1    13273
1   65563   65575   OR4F5

update - use the following for ROI BED: /gscmnt/gc2508/dinglab/fernanda/Germline_LUAD_LUSC/ReferenceFiles/Homo_sapiens.GRCh38.95.allCDS.2bpFlanks.biomart.withCHR.bed
-> this resolves the problem.  Update added to yaml file

