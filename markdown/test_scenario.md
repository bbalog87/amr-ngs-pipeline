# Testing AMR analysis pipeline 


## amrFlow Pipeline

This pipeline is designed to analyze NGS (Illumina PE) antimicrobial resistance (AMR) in bacterial genomes using Nextflow, a workflow management system. The pipeline checks if the required software tools are installed and clones the AMR NGS Pipeline repository from Github if it does not already exist. The pipeline then sets up the working environment by creating the installation directory if it does not exist, downloading the Miniconda3 installer, checking if Miniconda3 is already installed, and installing it if it is not. It also creates a new Conda environment and installs the required packages for each process. Finally, the pipeline sets up the config file based on the paramerters proved by users, an create the species-specific script (job) which is ran using the Nextflow with the specified reads path and organism name.

## Prerequisites

The following software tools are required to run the pipeline:
- Laptop/computrer with at least 16 GB RAM, optimally 32 GB
- Sufficient disc storage (> 50 GB free disc space)
- Linux system (Tested with Ubuntu Debian 22.04 and Linux Mint V2.21)


## Installation

No active installaion is needed. The ```amrFlow_setup.sh``` script handles the installation of dependenceis and worflow environments automatically.

This Bash script is used for setting up the system to running the antimicrobial resistance (AMR)
analysis pipeline. 
 - The setup script need to be executed for a each species.
 - Howver, the subsquent setup will be more light and faster since the syetmns will alred have the required tools and packages.
 - If the reads path, organism name, and MLST scheme are not provided, an error message is displayed. It also checks if the provided organism name 
   is in the valid species list of supported organisms (mainly GLASS priority pathogens).

To install the pipeline, follow these steps:



## Usage

To use the pipeline, run the following command in a Bash shell:

```
bash amrFlow_setup.sh -h
```

The following options are available:

- `-r` or `--reads`: Path to the directory containing the sequencing reads (REQUIRED)
- `-o` or `--organism`: Name of the bacterial species (REQUIRED)
- `-s` or `--mlst`: MLST scheme for your species (REQUIRED)
- `-h` or `--help`: Display help message and exit

### Example

To run the pipeline on sequencing reads in the directory `~/reads`, for the bacterial species `Escherichia` using the `ecoli` MLST scheme, run the following command:

```
bash amrFlow_setup.sh  -r ~/reads -o Escherichia -s ecoli

```
If sucesfull, this script will crreate Nextflow script in ```~/amrFlow/Escherichia.sh```, which can be execvuted with

```
bash ~/amrFlow/Escherichia.sh

```


The supported MLST scheme are provided [HERE](https://github.com/bbalog87/amr-ngs-pipeline/blob/main/markdown/mlst_sheme.md)

## Supported species

The pipeline supports the following bacterial species:

- Acinetobacter_baumannii
- Burkholderia_cepacia
- Burkholderia_pseudomallei
- Campylobacter
- Clostridioides_difficile
- Enterococcus_faecalis
- Enterococcus_faecium
- Escherichia
- Klebsiella_oxytoca
- Klebsiella_pneumoniae
- Neisseria_gonorrhoeae
- Neisseria_meningitidis
- Pseudomonas_aeruginosa
- Salmonella
- Staphylococcus_aureus
- Staphylococcus_pseudintermedius
- Streptococcus_agalactiae
- Streptococcus_pneumoniae
- Streptococcus_pyogenes
- Vibrio_cholerae

