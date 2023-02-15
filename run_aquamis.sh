#!/usr/bin/env bash

# Create AQUAMIS environment and install aquamis
mamba create -n aquamis_env -c conda-forge -c bioconda aquamis -y

# Activate AQUAMIS environment
conda activate aquamis_env

# Install BUSCO within AQUAMIS environment
mamba install -c bioconda busco -y

# Clone AQUAMIS repository
git clone https://gitlab.com/bfr_bioinformatics/AQUAMIS.git
cd AQUAMIS

# Install and setup databases
bash aquamis_setup.sh -d
cd ..

# Set database paths for AQUAMIS
WORK_DIR=/home/nguinkal/AMR-Workflows/AQUAMIS_output2 # Output directory
KRAKEN2_DB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/kraken
TAXONKIT_DB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/taxonkit
MASH_DB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/mash/mashDB.msh
READS_DIR=/home/nguinkal/AMR-Workflows/TestData-reads # Input data path for AQUAMIS
THREADS=8

# Create sample sheet using create_sampleSheet.sh script packaged in the environment
create_sampleSheet.sh --mode ncbi \
                      --fastxDir $READS_DIR \
                      --outDir $WORK_DIR \
                      --force 

# Details about --mode parameters:
# illumina: samples are in illumina format: {samplename}_S*_R{1,2}_001.fastq*
# ncbi: samples are in ncbi format: {samplename}_{1,2}.fastq.gz
# flex: samples are in the following format: {samplename}*_R{1,2}*.fastq*. 
# The sample name is cut after the first "_". If your sample name contains "_" the sample 
# name will be cropped!
# assembly: samples are in format {samplename}.fasta Note that currently only the extension ".fasta" is supported

# Run AQUAMIS with specified parameters
aquamis -l $WORK_DIR/samples.tsv \
        --taxlevel_qc S \
        -d $WORK_DIR \
        --min_trimmed_length 22 \
        --threads_sample $THREADS \
        --logdir . \
        --kraken2db $KRAKEN2_DB \
        --taxonkit_db $TAXONKIT_DB \
        -m $MASH_DB \
        -r Testing_with_Staphylococcus
