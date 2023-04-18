# Testing AMR analysis pipeline 


## amrFlow Pipeline

This pipeline is designed to analyze NGS (Illumina PE) antimicrobial resistance (AMR) in bacterial genomes using Nextflow, a workflow management system. The pipeline checks if the required software tools are installed and clones the AMR NGS Pipeline repository from Github if it does not already exist. The pipeline then sets up the working environment by creating the installation directory if it does not exist, downloading the Miniconda3 installer, checking if Miniconda3 is already installed, and installing it if it is not. It also creates a new Conda environment and installs the required packages for each process. Finally, the pipeline sets up the config file based on the paramerters proved by users, and runs the Nextflow pipeline with the specified reads path and organism name.

## Prerequisites

The following software tools are required to run the pipeline:
- Laptop/computrer with at least 16 GB RAM, optimally 32 GB
- Sufficient disc storage (> 50 GB free disc space)
- Linux system (Tested with Ubuntu Debian 22.04 and Linux Mint V2.21


## Installation

To install the pipeline, follow these steps:

1. Clone the repository using Git:

   ```
   git clone https://github.com/bbalog87/amr-ngs-pipeline.git
   ```

2. Change directory to the repository:

   ```
   cd amr-ngs-pipeline
   ```

3. Create a new Conda environment and install the required packages:

   ```
   conda create --name amrFlow
   conda activate amrFlow
   conda install --file requirements.txt
   ```

## Usage

To use the pipeline, run the following command in a Bash shell:

```
bash runAMR_workflow.sh [OPTIONS]
```

The following options are available:

- `-r` or `--reads`: Path to the directory containing the sequencing reads (REQUIRED)
- `-o` or `--organism`: Name of the bacterial species (REQUIRED)
- `-s` or `--mlst`: MLST scheme for your species (REQUIRED)
- `-h` or `--help`: Display help message and exit

### Example

To run the pipeline on sequencing reads in the directory `~/reads`, for the bacterial species `Escherichia` using the `Achtman` MLST scheme, run the following command:

```
bash runAMR_workflow.sh -r ~/reads -o Escherichia -s Achtman
```

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

