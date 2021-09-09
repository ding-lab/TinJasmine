class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: bcftools_normalize
baseCommand:
  - bcftools norm
inputs:
  - id: vcf
    type: File
    inputBinding:
      position: 0
outputs:
  - id: output
    type: File
    outputBinding:
      glob: output.normalized.vcf.gz
label: bcftools_normalize
arguments:
  - position: 0
    prefix: '--multiallelics'
    valueFrom: '-'
  - position: 0
    prefix: '--check-ref'
    valueFrom: w
  - position: 0
    prefix: '-O'
    valueFrom: z
  - position: 0
    prefix: '-o'
    valueFrom: output.normalized.vcf.gz
requirements:
  - class: DockerRequirement
    dockerPull: 'biocontainers/bcftools:v1.9-1-deb_cv1'
