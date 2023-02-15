
# AMRFinder Workflow process P3.2

This script installs and runs the `amrfinderplus` tool from NCBI's Antimicrobial Resistance (AMR) GeneFinder package. It first creates a dedicated environment to install the tool and its dependencies using the `mamba` package manager, then downloads the latest AMR database.

The script processes input files from the TORMES Out/annotation directory, performs AMR detection on the input sequences, and outputs the results to the AMRFinder_Out directory. The results are also consolidated into two files in the amrfinder_Results directory.

## Installation

Install `amrfinderplus` using `mamba` in a dedicated environment:

```bash
mamba create -y -c bioconda -c conda-forge -n amrfinder_Env ncbi-amrfinderplus
```

After installation, activate the amrfinder conda environment using the following command:

```conda activate amrfinder_Env```

## Downloading AMRFinder Database

Download the latest AMRFinder database using the command: ```amrfinder -u```

## Input Data
The input data should be placed in a directory named "amrfinderINPUT". 
The following command copies the input files from the TORMES_Out directory to this directory:
```bash
TORMES_ANNO=/home/nguinkal/AMR-Workflows/TORMES_Out/annotation
mkdir -p amrfinderINPUT && find $TORMES_ANNO/ \ 
-type f −name"∗.faa"−o−name"∗.gff"−o−name"∗.fna"−name"∗.faa"−o−name"∗.gff"−o−name"∗.fna" -exec cp {} amrfinderINPUT/ ;
```

The script takes as input a set of genome sequences in FASTA format, but also protein sequences along with gff annotations located in the amrfinderINPUT directory. The input directory is created automatically if it does not exist. The input directory is populated by copying all files with extensions .faa, .gff, and .fna from the TORMES_Out/annotation directory.



