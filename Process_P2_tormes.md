# TORMES Workflow Documentation

## Introduction 

The TORMES pipeline is designed to identify antibiotic resistance genes (ARGs) and plasmids in microbial genomes, with a focus on identifying novel resistance genes not found in existing databases. This pipeline consists of several steps, including taxonomic classification, genome assembly, and gene prediction, and has a number of dependencies, including the Kraken2 taxonomic classifier, the SPAdes genome assembler, and the Prodigal gene predictor.

The code provided is a Bash script that automates the execution of the TORMES pipeline. It includes the following steps:
