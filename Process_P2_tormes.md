# TORMES Workflow Documentation

## Introduction 

The TORMES pipeline is designed to identify antibiotic resistance genes (ARGs) and plasmids in microbial genomes, with a focus on identifying novel resistance genes not found in existing databases. This pipeline consists of several steps, including taxonomic classification, genome assembly, and gene prediction, and has a number of dependencies, including the Kraken2 taxonomic classifier, the SPAdes genome assembler, and the Prodigal gene predictor.

The code provided is a Bash script that automates the execution of the TORMES pipeline. It includes the following steps:


## Step 1: Set Variables

The first step in the script is to set the variables that will be used throughout the pipeline. These variables include:

 - READS: The path to the directory containing the input reads (not strictly needed for TORMES).
 - GENOMES: The path to the directory containing the input genomes built by AQUAMIS, which are the main input to TORMES.
 - WORK_DIR: The path to the working directory for the pipeline.


```bash
READS=/home/nguinkal/AMR-Workflows/TestData-reads ## path to reads (not really needed)

## path to assemblies built by AQUAMIS, which are the main input to TORMES
GENOMES=/home/nguinkal/AMR-Workflows/AQUAMIS_output2/Assembly/assembly 

## Working directory
WORK_DIR=/home/nguinkal/AMR-Workflows/

# Download configuration
wget https://anaconda.org/nmquijada/tormes-1.3.0/2021.06.08.113021/download/tormes-1.3.0.yml

```
