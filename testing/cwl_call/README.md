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
