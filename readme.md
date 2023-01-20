# AmrFlow: A Nextlow pipeline for AMR detection and profiling for bacterial isolates
A Nextflow pipeline for NGS antimicrobial resistance profiling; from raw NGS FASTQ to rendered AMR profiles.

### Pipeline with NGS FASTQ files
Starting with raw NGS FASTQ files,the pipeline includes the following processes (P):

- P1 - Quality Control (QC): [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) is used for visual inspection of raw reads tidentify low quality data and potential issues

- P2 - Trimming: [Fastp](https://github.com/OpenGene/fastp) is used to trim low qaulity reads. This step also includes QC filtering.\
    Alternatively, [AQUAMIS](https://gitlab.com/bfr_bioinformatics/AQUAMIS) would replace P1 and P2.
    
 - P3: Analysis : \
   alternative Worklows with custamizations : [Nullarbor](https://github.com/tseemann/nullarbor), [TORMES](https://github.com/nmquijada/tormes), [abritAMR](https://github.com/MDU-PHL/abritamr). 
   
   
 - P4 - Rendering customized reports:  Markdown, html, pdf, tsv ...

 - P5 - Preliminary vizualizataions and statistics : R/Tidyverse
 
 - P6 - R scripts to peform AMR statistical data analysis : [AMR](https://github.com/msberends/AMR)
 - P7 - Integrate genomic-driven epidemiolgiacl and public health surveilance tools: [Nextrains](https://nextstrain.org/), [Microreact](https://docs.microreact.org/)



### Execution mode and computing ressources
 - Local/laptop or HPC?
 - Sample laod
 - Data volume
