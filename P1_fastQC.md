# Introduction

This is a wrapper to perform initial quality control (QC) on raw reads using the FastQC command line tool.
The script takes paired-end reads in fastq format as input and outputs QC results in an HTML format.

``run_fastqc.sh`` is a Bash script that performs initial quality control (QC) on raw reads using the FastQC command line tool. This script takes as input a directory containing paired-end reads in Fastq format and outputs a set of reports containing QC metrics and graphics for each sample, one per read file. The reports are generated using FastQC, a popular tool for assessing the quality of high-throughput sequencing data.

The script checks the input directory and output directory for existence, and runs FastQC on each sample in parallel using the specified number of threads. The output is organized in subdirectories, one for each sample.
