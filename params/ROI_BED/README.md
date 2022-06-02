
### Parameter files

Previously, used 
/storage1/fs1/dinglab/Active/Projects/CPTAC3/Analysis/CromwellRunner/TinJasmine/02.PDA5/Workflow/TinJasmine/params/ROI_BED/Homo_sapiens.GRCh38.95.allCDS.2bpFlanks.biomart.withCHR.bed

This is from Fernanda, developed here:
/gscmnt/gc2508/dinglab/fernanda/Germline_LUAD_LUSC/ReferenceFiles/Homo_sapiens.GRCh38.95.allCDS.2bpFlanks.biomart.withCHR.bed

#### ROI
Updated for v100 and v102.  From Fernanda:
```
So I have generated the ROI BED files for gencode34 and gencode36 (vep 100 and 102, respectively), which you’ll need for TinJasmine’s ROI filter step.
The files are located here:
/storage1/fs1/dinglab/Active/Projects/fernanda/Projects/PECGS/BED_files_ROI
You’ll see three files within each gencode_3\* subdirectory:
* a gtf.gz file downloaded from Ensembl, which is the source file used to generate the bed file
* a .allCDS.1based.2bpFlanks.bed which is the ROI file, with  chromosomes labeled only as numbers
* a .allCDS.1based.2bpFlanks.withCHR.bed which is  the same ROI bed file, but with chromosomes preceded by a chr. This will match GDC’s reference genome chromosome nomenclature.

I had previously generated these bed files using Ensembl’s Biomart web-based
tool, but I noticed that the tool has changed over  the different releases,
which makes  it  difficult to have other people reproduce results.  So I wrote
a little script to create the BED file from the .gtf.gz file downloaded from
Ensembl. The script is  also  located in that folder.  You will also find a
README file there  with how the bed files were generated and what they entail.
```

