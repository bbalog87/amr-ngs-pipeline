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
