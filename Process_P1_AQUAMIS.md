# AQUAMIS Process Documentation
## Introduction
This documentation provides a step-by-step guide on how to install and set up [AQUAMIS](https://gitlab.com/bfr_bioinformatics/AQUAMIS) (Antibiotic Resistance QUAlity control for Metagenomic data using Kraken2, tAxonKit, and MASH), a workflow that performs quality control of metagenomic data prior to performing antibiotic resistance genes identification


## Prerequisites

  - A Linux environment
  - Conda or Mamba package manager
   - AQUAMIS installed in a Conda environment
  - Git installed in the Linux environment


## Installation

1. Clone the AQUAMIS repository from the GitLab repository:
   ```bash
   git clone https://gitlab.com/bfr_bioinformatics/AQUAMIS.git && cd AQUAMIS 
   ```
2. Create a Conda environment for AQUAMIS and activate aquamis_env :
```bash 
mamba create -n aquamis_Env -c conda-forge -c bioconda aquamis -y && conda activate aquamis_Env
```
3. Install BUSCO within the AQUAMIS environment:
```bash

mamba install -c bioconda busco -y
```

### Usage

The script automates the following steps:

 4. Set up the AQUAMIS databases
 5. Create a sample sheet for AQUAMIS
 6. Run AQUAMIS on the input data

### Set up AQUAMIS databases:

Before running AQUAMIS, you must set up the necessary databases. Run the following command to set up the databases:

```bash

bash aquamis_setup.sh -d
```
 ###  Set the following variables to the appropriate values in your terminal:
```ruby
 WorkDir=/home/nguinkal/AMR-Workflows/AQUAMIS_output2  # output directory
KRAKEN2DB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/kraken  # Kraken2 database path
TAXONKITDB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/taxonkit  # taxonkit database path
MASHDB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/mash/mashDB.msh  # MASH database path
READS_DIR=~/AMR-Workflows/TestData-reads  # path to input data directory
THREADS=8  # number of threads to use
```

## Create a sample sheet for AQUAMIS

Create a sample sheet for AQUAMIS using the ``create_sampleSheet.sh`` script. Use the following command:

```javascript
create_sampleSheet.sh --mode ncbi \ 
                      --fastxDir /path/to/fastxDir \  
                      --outDir /path/to/outDir \    
                      --force
```
My example:


```lua

aquamis -l $WorkDir/samples.tsv \
       --taxlevel_qc S -d $WorkDir \
       --min_trimmed_length 22 \
       --threads_sample $THREADS \
       --logdir . \
       --kraken2db $KRAKEN2DB \
       --taxonkit_db $TAXONKITDB \
       -m $MASHDB \
       -r Testing_with_Staphyloccus
```
This script will generate a samples.tsv file in the output directory.

The --mode parameter can be set to ``illumina, ncbi, flex, or assembly`` depending on the format of the input files.

## Run AQUAMIS on the input data

To run AQUAMIS on the input data, use the following command:

```R

aquamis -l /path/to/samples.tsv \
        --taxlevel_qc S \
        -d /path/to/output_dir \
        --min_trimmed_length 22 \
        --threads_sample $THREADS \
        --logdir . \
        --kraken2db /path/to/kraken2 \
        --taxonkit_db /path/to/taxonkit \
        -m /path/to/mash \
        -r run_name
        
  ```
      
 My example:
 
 ```javascript
 aquamis -l $WorkDir/samples.tsv \
 --taxlevel_qc S -d $WorkDir \
 --min_trimmed_length 22 \
 --threads_sample $THREADS \
 --logdir . \
 --kraken2db $KRAKEN2DB \
 --taxonkit_db $TAXONKITDB \
 -m $MASHDB \
 -r Testing_with_Staphyloccus
 
```


Replace ``/path/to/samples.tsv, /path/to/output_dir, /path/to/kraken2, /path/to/taxonkit, /path/to/mash```, and run_name with the appropriate values.

```
    --taxlevel_qc: Set to S to perform species-level QC
    --threads_sample: Number of threads to use for each sample. Replace $THREADS with the desired number.
    -r: A name for the AQUAMIS
    
 ```
