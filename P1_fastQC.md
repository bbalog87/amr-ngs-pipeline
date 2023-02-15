# Introduction

This is a wrapper to perform initial quality control (QC) on raw reads using the FastQC command line tool.
The script takes paired-end reads in fastq format as input and outputs QC results in an HTML format.

``run_fastqc.sh`` is a Bash script that performs initial quality control (QC) on raw reads using the FastQC command line tool.
This script takes as input a directory containing paired-end reads in Fastq format and outputs a set of reports containing
QC metrics and graphics for each sample, one per read file. The reports are generated using FastQC, a popular tool for 
assessing the quality of high-throughput sequencing data. The script checks the input directory and output directory for 
existence, and runs FastQC on each sample in parallel using the specified number of threads.
The output is organized in subdirectories, one for each sample.

## Installation

You can install FastQC using conda or mamba by creating a new environment and
installing it in that environment. Here are the steps to do so:


  1.  Create a new environment for FastQC using either conda or mamba:

    For conda:
    
     conda create --name fastqc_Env
     
  2. Activate the new environment:
     ``conda activate fastqc_Env``
 

 3. Install FastQC:

``mamba install -c bioconda fastqc``

4. FastQC should now be installed in your environment.

Note: The -c bioconda option specifies the Bioconda channel from which to install FastQC. 
If you have already added the Bioconda channel to your list of channels, you can omit this option.
