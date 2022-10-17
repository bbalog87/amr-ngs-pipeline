# AmrFlow: AMR detection and proflining pipeline for bacterial isolates
A Nextflow pipeline for NGS antimicrobial resistance profiling; from raw NGS FASTQ to rendered AMR profiles.

### Pipeline with NGS FASTQ files
Starting with raw NGS FASTQ files,the pipeline includes the following steps:

- P1 - Quality Control (QC): [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) is used for visual inspection of raw reads tidentify low quality data and potential issues

- P2 - Trimming: [Fastp](https://github.com/OpenGene/fastp) is used to trim low qaulity reads. This step also includes QC filtering.\
    Alternatively, [AQUAMIS](https://gitlab.com/bfr_bioinformatics/AQUAMIS) would replace P1 and P2.
    
 - P3: Analysis : \
   alternatuve Worklows : [Nullarbor](https://github.com/tseemann/nullarbor), [TORMES](https://github.com/nmquijada/tormes), 
   
   
   - P4 - Rendering customized reports  Markdown, html, pdf, ...


### Execution mode and compuition ressources
 - Local, HPC?
