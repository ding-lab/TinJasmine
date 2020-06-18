This is a continuation from run 5 of ../cwl-call, with a new workflow
which starts after variant calling and preliminary filtering, immediately
before VLD Filter calls.  This simplifies testing of downstream filtering
without waiting for long initial calling to conclude

# Run 1

Fails at VEP annotate step.  From stderr,

/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/79314509-9207-4d20-8a30-a238777bce9f/call-vep_annotate/execution/stderr

```
-------------------- EXCEPTION --------------------
MSG:
ERROR: Forked process(es) died: read-through of cross-process communication detected

STACK Bio::EnsEMBL::VEP::Runner::_forked_buffer_to_output /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/Runner.pm:556
STACK Bio::EnsEMBL::VEP::Runner::next_output_line /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/Runner.pm:361
STACK Bio::EnsEMBL::VEP::Runner::run /usr/local/ensembl-vep/modules/Bio/EnsEMBL/VEP/Runner.pm:202
STACK toplevel /usr/local/ensembl-vep/vep:224
Date (localtime)    = Tue Jun 16 19:31:35 2020
Ensembl API version = 99
---------------------------------------------------
Error executing: /usr/bin/perl /usr/local/ensembl-vep/vep --failed 0 --everything --af_exac --flag_pick --assembly GRCh38 --cache_version 99 --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 10000 --offline --cache --dir ./vep-cache --fork 4 --format vcf --vcf -i /cromwell-executions/TinJasmine-postcall.cwl/79314509-9207-4d20-8a30-a238777bce9f/call-vep_annotate/inputs/-964738032/HotspotFiltered.vcf -o results/vep/output_vep.vcf --force_overwrite  --fasta /cromwell-executions/TinJasmine-postcall.cwl/79314509-9207-4d20-8a30-a238777bce9f/call-vep_annotate/inputs/-365693757/GRCh38.d1.vd1.fa
```

This may be affected by --fork, --buffer_size, or memory ( https://github.com/Ensembl/ensembl-vep/issues/150 )

input into vep_annotate is output of ROI filter,
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/79314509-9207-4d20-8a30-a238777bce9f/call-roi_filter/execution/output/HotspotFiltered.vcf

Note that this file has multiple repeated VCF entries.

# Run 2

Restarting as before, with the changes,
* HotspotFilter has `-u` added to `bedtools intersect` calls to deal with duplicate entries
* VCF_Annotate memory requirement increased to 8G - hopefully that helps with the crashes

## Error
In,
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/36ae3517-77b2-4a69-80fd-68908bfd7c54/call-vep_annotate/execution/stderr

Same error as above.  Confirmed that memory was increased.

## Moving forward

Analysis will be in isolated VEP Annotate container, but we need to have full control over parameters we pass.

### Parameter passing update
Currently, the following parameters are hard-coded into GenomeVIP/vep_annotator.pl:
    --buffer_size 10000  --fork 4
and if VEP Cache is enabled,
    --af --max_af --af_1kg --af_esp --af_gnomad

We are moving the above parameters to vep options, 

The plan going forward, to minimize future changes to code, is to require that all of these be passed as VEP Options.
This is an argument in VEP_annotate/cwl/vep_annotate.TinJasmine.cwl, whose current value is,
    valueFrom: '--failed 0 --everything --af_exac'

-> propose removing all non-passed arguments in vep_annotator.pl and making this be,
    valueFrom: '--failed 0 --everything --af_exac --buffer_size 10000  --fork 4 --af --max_af --af_1kg --af_esp --af_gnomad'

-> note that these arguments are specific to TinDaisy, and are not applicable to TinJasmine:
    --af --max_af --af_1kg --af_esp --af_gnomad

these have been added to vep_annotate.TinJasmine.cwl

### Debugging memory

To make things easier when debugging cromwell output, we will mount cromwell-executions.
CE=/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions
mounted as /cromwell-executions.  All pahts will then match what's on logs

Start at output of prior step, roi_filter.  Path:
VCF_IN="/cromwell-executions/TinJasmine-postcall.cwl/36ae3517-77b2-4a69-80fd-68908bfd7c54/call-roi_filter/execution/output/HotspotFiltered.vcf"

As a start, use `testing/direct_call/2_vep_annotate_cache.sh` to run vep and try to reproduce this error with the parameters we have.
* we will use existing cache rather than uncompressing new one
    VEP_CACHE=/cromwell-executions/TinJasmine-postcall.cwl/36ae3517-77b2-4a69-80fd-68908bfd7c54/call-vep_annotate/execution/vep-cache

REF="/cromwell-executions/TinJasmine-postcall.cwl/36ae3517-77b2-4a69-80fd-68908bfd7c54/call-vep_annotate/inputs/-365693757/GRCh38.d1.vd1.fa"

-> I can in fact reproduce this quickly
Using TinJasmine arguments, the following work and fail, only constant variables noted:

--buffer_size 10000  --fork 4     - failed
--buffer_size 10000  --fork 2     - failed
--buffer_size 5000  --fork 2      - failed
--buffer_size 50  --fork 2        - this worked
--buffer_size 500  --fork 4       - this worked

-> when works, confirm VEP format with Fernanda

-> will use --buffer_size 500  --fork 4 going forward

# Run 3

With VEP cache updates implemented, starting again
-> success!

TinJasmine-postcall.cwl.clean_MAF: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/0a5b12e4-e40f-4d51-abcf-8b6b167638ef/call-vcf2maf/execution/result.maf
TinJasmine-postcall.cwl.clean_VCF: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/0a5b12e4-e40f-4d51-abcf-8b6b167638ef/call-canonical_filter/execution/output/HotspotFiltered.vcf
TinJasmine-postcall.cwl.allCall_VCF: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/0a5b12e4-e40f-4d51-abcf-8b6b167638ef/call-vep_annotate/execution/results/vep/output_vep.vcf

-> comparing clean and allCall VCF, it does not seem like hotspot filter did anything
Hotspot filter output: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/0a5b12e4-e40f-4d51-abcf-8b6b167638ef/call-roi_filter/execution/output/HotspotFiltered.vcf
Hotspot filter input: /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/TinJasmine-postcall.cwl/0a5b12e4-e40f-4d51-abcf-8b6b167638ef/call-roi_filter/inputs/731768474/filtered.vcf

-> filtering did take place, but rejected variants were not retained
-> HotspotFilter is not designed to add FILTER fields.  If make VCF_A = VCF_B, then can distinguish the calls by the HOTSPOT=A or =B in INFO field

