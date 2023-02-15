# TORMES Workflow Documentation

## Introduction 

The TORMES pipeline is designed to identify antibiotic resistance genes (ARGs) and plasmids in microbial genomes, with a focus on identifying novel resistance genes not found in existing databases. This pipeline consists of several steps, including taxonomic classification, genome assembly, and gene prediction, and has a number of dependencies, including the Kraken2 taxonomic classifier, the SPAdes genome assembler, and the Prodigal gene predictor.

The code provided is a Bash script that automates the execution of the TORMES pipeline. It includes the following steps:


## Step 1: Set Variables

The first step in the script is to set the variables that will be used throughout the pipeline. These variables include:

 - READS: The path to the directory containing the input reads (not strictly needed for TORMES).
 - GENOMES: The path to the directory containing the input genomes built by AQUAMIS, which are the main input to TORMES.
 - WORK_DIR: The path to the working directory for the pipeline.

The script downloads a YAML configuration file for TORMES, which specifies the dependencies that need to be installed to run the pipeline.
```bash
READS=/home/nguinkal/AMR-Workflows/TestData-reads ## path to reads (not really needed)

## path to assemblies built by AQUAMIS, which are the main input to TORMES
GENOMES=/home/nguinkal/AMR-Workflows/AQUAMIS_output2/Assembly/assembly 

## Working directory
WORK_DIR=/home/nguinkal/AMR-Workflows/


```
The script starts by setting some variables for the input and output directories. Then, it downloads the configuration file for TORMES.

## Step 2: Download TORMES Configuration


```

# Download configuration
wget https://anaconda.org/nmquijada/tormes-1.3.0/2021.06.08.113021/download/tormes-1.3.0.yml


```

## Step 3: Create TORMES Environment

The script creates a Conda environment called tormes_Env and installs the dependencies specified in the TORMES configuration file. It then activates the TORMES environment.

```
### create tormes_env, and install dependencies in tormes-1.3.0.yml 
mamba env create -n tormes_Env --file tormes-1.3.0.yml

## activate tormes environment
conda activate tormes_Env


# Additionally, the first time you are using TORMES, run (after activating TORMES environment)
# to setup tormes
tormes-setup

```


## Step 4: TORMES Setup

The script runs the tormes-setup command, which sets up TORMES by downloading and installing additional dependencies not available in Conda. 
This step also creates a configuration file required for TORMES to function.


```

# Additionally, the first time you are using TORMES, run (after activating TORMES environment)
# to setup tormes
tormes-setup

```

Additionally, the following R packages may need to be installed using conda:

  - ggtree
  - knitr
  - plotly
  - RColorBrewer
  - reshape2
  - rmarkdown
  - treeio


