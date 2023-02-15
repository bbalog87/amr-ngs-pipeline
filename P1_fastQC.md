# Introduction

This is a wrapper to perform initial quality control (QC) on raw reads using the FastQC command line tool.
The script takes paired-end reads in fastq format as input and outputs QC results in an HTML format.

``run_fastqc.sh`` is a Bash script that performs initial quality control (QC) on raw reads using the FastQC command line tool.
This script takes as input a directory containing paired-end reads in Fastq format and outputs a set of reports containing
QC metrics and graphics for each sample, one per read file. The reports are generated using FastQC, a popular tool for 
assessing the quality of high-throughput sequencing data. The script checks the input directory and output directory for 
existence, and runs FastQC on each sample in parallel using the specified number of threads.
The output is organized in subdirectories, one for each sample.


## Prerequisites

Before running run_fastqc.sh you need to have the following software installed on your system:

 - [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) version 0.11.9 or later.

FastQC should be installed and in your PATH, or you should specify the path to the FastQC binary using the -f option.

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


## Usage

The usage of the script is as follows:

``run_fastqc.sh -d <directory> [-t <threads>] [-o <output_directory>] [-f <fastqc_binary>] ``


Where:

    -d <directory>: specifies the input directory containing paired reads in Fastq format. This is a required parameter.
    -t <threads>: specifies the number of threads to use for FastQC analysis. The default is 8 threads.
    -o <output_directory>: specifies the output directory for FastQC results. The default is ./FastQC_output.
    -f <fastqc_binary>: specifies the path to the FastQC binary. The default is fastqc.



## Workflow

The script runs as follows:

  1. Check the input parameters and options.
  2. Check if the input directory exists and is not empty.
  3. Check if the output directory exists, and create it if it does not.
  4. Check if the FastQC binary is installed and in the PATH or specified by the user.
  5. Run FastQC on each sample in parallel using the specified number of threads.
  6. Check for errors and print a summary message when the analysis is completed.


## Command Line Options

The script takes the following command line options:

   - -d <directory>: specifies the input directory containing paired reads in Fastq format. This is a required parameter.
   - -t <threads>: specifies the number of threads to use for FastQC analysis. The default is 8 threads.
   - -o <output_directory>: specifies the output directory for FastQC results. The default is ./FastQC_output.
  -  -f <fastqc_binary>: specifies the path to the FastQC binary. The default is fastqc.
   - -h: prints a help message with the script usage and options.

 
## Error Checking

The script performs error checking on the input directory, output directory, and FastQC binary. It checks that the input directory exists and is not empty, that the output directory exists or can be created, and that the FastQC binary is installed and in the PATH or specified by the user.
 
## Parallel Execution

The script runs FastQC on each sample in parallel using the specified number of threads. It uses the set -e, set -u, and set -o pipefail commands to ensure that any command that fails will cause the script to exit immediately.
 
## Output Files

The output files are organized in subdirectories, one for each sample. The subdirectories 
