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
 
 ## Script
 
 ```python
 
 
 #!/usr/bin/env bash

# Author: Julien Nguinkal
# Date: [2023-01-20]
# Description: This is a wrapper to perform initial QC on raw reads using the FastQC command line tool

# Exit if any command exits with a non-zero status
set -e
# Exit if any variable is unset
set -u

# Exit if any command in a pipeline exits with a non-zero status
set -o pipefail

#### Color on terminal output

BBlue='\033[1;34m' 
RED='\033[0;31m'
NOCOLOR='\033[0m'

### Check user inputs
CPUS=8
OUT=./FastQC_output
FASTQC_BINARY=fastqc

usage() {
    echo "Usage: $0 -d <directory> -t <threads> -o <output_directory> -f <fastqc_binary>"
    echo " -d <directory> : specify the directory containing paired reads"
    echo " -t <threads> : specify the number of threads to use for fastqc (default: 8)"
    echo " -o <output_directory> : specify the output directory for fastqc results (default: ./FastQC_output)"
    echo " -f <fastqc_binary> : specify the path to fastqc binary (default: fastqc)"
    exit 1
}



### Check user inputs

while getopts ":d:t:o:f:h" opt; do

    case $opt in
        d)
            READS_DIR="$OPTARG"
            ;;
        t)
            CPUS="$OPTARG"
            ;;
        o)
            OUT="$OPTARG"
            ;;
        f)
            FASTQC_BINARY="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
		h)
            usage
            ;;
    esac
done


if [[ "${@:$OPTIND}" =~ "-h" || "${@:$OPTIND}" =~ "--help" ]]; then
    usage
fi


if [ $# -eq 0 ]
then
    echo "Use -d <directory> to specify the directory containing paired reads"
	 echo "Use -h or -help to print extensisve options"
    exit 1
fi


## Print start of the process and date time
echo "==========================" 
START_DATE_TIME=$(date +'%Y-%m-%d %H:%M:%S')
echo -e  "${BBlue}$START_DATE_TIME : RUNNING ...fastqc for all samples...${NOCOLOR}" 
 echo "==========================" 

# Check if the READS_DIR directory exists and contains fastq files
if [ ! -d "$READS_DIR" ] || [ -z "$(ls -A $READS_DIR)" ]; then
    echo "Error: $READS_DIR directory does not exist or is empty."
    exit 1
fi


# Check if the output directory exists
if [ -d "$OUT" ]; then
    echo "Warning: Output directory already exists. Files may be overwritten."
else
    mkdir -p $OUT
fi

# Check if fastqc is installed and in the PATH or specified by user
if [ -z "$FASTQC_BINARY" ]; then
    if ! command -v fastqc > /dev/null; then
        echo "Error: fastqc is not installed or not in the PATH."
        exit 1
    fi
else
    if ! command -v "$FASTQC_BINARY" > /dev/null; then
        echo "Error: fastqc binary not found at $FASTQC_BINARY"
        exit 1
    fi
fi

# Run fastqc to check reads quality - Visual inspection needed.
for file in $READS_DIR/*_1.fastq; do
    base=${file%_1.fastq} ## sample name
    fwd=$file ## forward reads
    rev="$base"_2.fastq ## reverse reads
    # Check if the reverse read file exists
    if [[ ! -f "$rev" ]]; then
        echo "Error: $rev does not exist."
        exit 1
    fi
    mkdir -p $OUT/$base/ ## output dir for each sample
    $FASTQC_BINARY $fwd $rev -t $CPUS -o $OUT/$base/
    # check for errors
    if [ $? -ne 0 ]; then
        echo "Error: fastqc failed for $fwd and $rev"
        exit 1
    fi
done

echo "==========================" 
START_DATE_TIME=$(date +'%Y-%m-%d %H:%M:%S')
echo -e  "${BBlue}$START_DATE_TIME : fastqc processing completed successfully for all samples. Have fun!${NOCOLOR}" 
echo "==========================" 

```
 
 

 
## Error Checking

The script performs error checking on the input directory, output directory, and FastQC binary. It checks that the input directory exists and is not empty, that the output directory exists or can be created, and that the FastQC binary is installed and in the PATH or specified by the user.
 
## Parallel Execution

The script runs FastQC on each sample in parallel using the specified number of threads. It uses the set -e, set -u, and set -o pipefail commands to ensure that any command that fails will cause the script to exit immediately.
 
## Output Files

The script will output the FastQC results for each sample to the output directory specified by the user. 
The output will be organized in a subdirectory for each sample, and will include an HTML report as well as a zip file containing the raw results.
 
 
 ## Troubleshooting

Here are some tips for troubleshooting issues that may arise when running the script:

   - If the script fails to run, make sure that you have provided all of the required command line arguments, and that the input directory exists and contains fastq files.

  - If the script fails to find the fastqc binary, make sure that it is installed and in the PATH, or specify the path to the binary using the -f argument.

   - If the script fails to complete fastqc analysis for a sample, check the error message and make sure that both the forward and reverse reads are present and correctly named in the input directory.

 ## Conclusion
This script provides a simple and convenient way to perform initial QC on raw reads using the FastQC command line tool.
 With just a few command line arguments, users can quickly and easily analyze the quality of their sequencing data 
 and identify any potential issues.
This script is as a starting point for QC sequencing data, before running process P2 including AQUAMIS and fastp.
