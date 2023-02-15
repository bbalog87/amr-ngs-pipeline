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
This step downloads and installs additional dependencies required for TORMES and Kraken2. It also downloads the MiniKraken2 v1 8GB database required for Kraken2 to function. If the user has enough disk space and RAM power, it is recommended downloading and installing the "Standard Kraken2 Database" provided by Kraken2 developers for improved taxonomic identification.


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

## Step 5: Create Metadata for Input Reads and Genomes

The script creates metadata files for the input reads and genomes. These metadata files are used to tell TORMES which samples to process and to provide a description of each sample. The metadata files are created by parsing the file names in the input reads and genomes directories.



The script creates metadata files for the reads and genomes as input to TORMES. The metadata files contain information about the samples and the corresponding files.

Metadata for Reads:

The metadata file for reads is created using the following steps:

    A list of the sample names is created by extracting the prefix of the file names using sed.
    The paths to the corresponding read files are obtained using realpath.
    The sample names, read file paths, and a description are combined using paste.
    The metadata file is saved as myMetadataReads.txt.

Metadata for Genomes:

The metadata file for genomes is created using the following steps:

    A list of the sample names is created by extracting the prefix of the file names using sed.
    The paths to the corresponding genome files are obtained using realpath.
    The sample names, genome file paths, and a description are combined using paste.
    The metadata file is saved as myMetadataGenomes.txt.
 ```   
  ### Create metadata for reads
# List all files in the READS directory with the suffix _1.fastq and extract the sample names from the filenames
ls $READS/*_1* | sed "s/.*\///" | sed "s/_1.fastq//" > uno.tmp

# Generate the full paths to the read files for each sample and output to dos.tmp and tres.tmp
for i in $(<uno.tmp); do realpath $READ/${i}_1.fastq >> dos.tmp; realpath $READ/${i}_2.fastq >> tres.tmp; done

# Add a description to each sample and output to cuatro.tmp
for i in $(<uno.tmp); do echo "This is ${i}" >> cuatro.tmp; done

# Combine the metadata into a single file and add column headers
paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > $WORK_DIR/myMetadataReads.txt

# Remove temporary files
rm *tmp

```

After creating the metadata files for the reads and genome assemblies, the script sets some parameters for TORMES, including the path to the metadata file, output directory, and number of threads to use for the analysis.

```lua

### Tormes parameters

META=/home/nguinkal/AMR-Workflows/myMetadataGenomes.txt
OUTDIR=TORMES_Out
THREADS=8
```

## Step 6: Run TORMES

The script runs TORMES with the specified metadata file, output directory, and number of threads.


```R

### Run Tormes now:
 
 tormes -m $META -o $OUTDIR -t $THREADS
```

TORMES will use the metadata file to match reads and genome assemblies and perform a taxonomic classification. The output will be written to the specified output directory.
