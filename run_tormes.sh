#/bin/bash

set -e


### TORMES process:


READS=/home/nguinkal/AMR-Workflows/TestData-reads ## path to reads (not really needed)

## path to assemblies built by AQUAMIS, which are the main input to TORMES
GENOMES=/home/nguinkal/AMR-Workflows/AQUAMIS_output2/Assembly/assembly 

## Working directory

WORK_DIR=/home/nguinkal/AMR-Workflows/

# Download configuration

wget https://anaconda.org/nmquijada/tormes-1.3.0/2021.06.08.113021/download/tormes-1.3.0.yml


### create tormes_env, and install dependencies in tormes-1.3.0.yml 
mamba env create -n tormes_Env --file tormes-1.3.0.yml

## activate tormes environment
conda activate tormes_Env

# Additionally, the first time you are using TORMES, run (after activating TORMES environment)
# to setup tormes
tormes-setup


# This step will install additional dependencies not available in conda and will 
# automatically create the config file.txt required for TORMES to function (see below). 
# This script will download the MiniKraken2 v1 8GB database required for Kraken2 to function.
# This database occupies 8 GB of disk space and is downloaded by default in order to facilitate 
# TORMES installation. If the user has enough disk space and RAM power, we recommend
# downloading and installing the "Standard Kraken2 Database" by following the instructions 
# provided by Kraken2 developers. The "Standard Kraken2 Database" will improve the sensitivity 
# of taxonomic identification. This is not required to run TORMES. It will also work with 
# the MiniKraken2 v1 8GB.


### It may be neccessary to additionally install following R package using conda:
#R packages: ggtree, knitr, plotly, RColorBrewer, reshape2, rmarkdown, treeio

### Create metadata for reads
ls $READS/*_1* | sed "s/.*\///" | sed "s/_1.fastq//" > uno.tmp
for i in $(<uno.tmp); do realpath $READ/${i}_1.fastq >> dos.tmp; realpath $READ/${i}_2.fastq >> tres.tmp; done
for i in $(<uno.tmp); do echo "This is ${i}" >> cuatro.tmp; done
paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > $WORK_DIR/myMetadataReads.txt
rm *tmp

## Create meta data for genome assmeblies (e.g built by AQUAMIS)

ls $GENOMES/*fasta | sed "s/.*\///" | sed "s/.fasta//" > uno.tmp
for i in $(<uno.tmp); do echo "GENOME" >> dos.tmp; realpath $GENOMES/${i}.fasta >> tres.tmp; done
for i in $(<uno.tmp); do echo "This is the genome for ${i}" >> cuatro.tmp; done
paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > $WORK_DIR/myMetadataGenomes.txt
rm *tmp


### Tormes parameters

META=/home/nguinkal/AMR-Workflows/myMetadataGenomes.txt
OUTDIR=TORMES_Out
THREADS=8

 ### Run Tormes now:
 
 tormes -m $META -o $OUTDIR -t $THREADS



