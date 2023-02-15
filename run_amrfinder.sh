#!/bin/bash
#set -e

## Install amrfinderplus using bioconda in a dedicated environment
## Find more here https://github.com/ncbi/amr/wiki/Install-with-bioconda
## Note: use mamba instead of conda

CONDA_ENV_NAME="amrfinder_Env"
CONDA_CHANNELS="-c bioconda -c conda-forge"

## run this only once
mamba create -y $CONDA_CHANNELS -n $CONDA_ENV_NAME ncbi-amrfinderplus 

## activate amarfinder conda environment
source activate $CONDA_ENV_NAME

# Download latest amrfinder database

amrfinder -u

# Set input and output paths
TORMES_ANNO="/home/nguinkal/AMR-Workflows/TORMES_Out/annotation" ## The output of TORMES in Process P3.
INPUT_FOLDER="amrfinderINPUT" # default input
OUTPUT_FOLDER="AMRFinder_Out" ## default output folder
RESULTS_FOLDER="amrfinder_Results" ## default results folder

## create output and results directories
mkdir -p $INPUT_FOLDER
mkdir -p $OUTPUT_FOLDER
mkdir -p $RESULTS_FOLDER

## Copy files from TORMES annotation directory to input folder
find $TORMES_ANNO/ -type f \( -name "*.faa" -o -name "*.gff" -o -name "*.fna" \) \
    -exec cp {} $INPUT_FOLDER/ \;

## make all files executable in input folder
chmod +rwx $INPUT_FOLDER/*

## Organism and thread count
ORGANISM="Staphylococcus_aureus" ## default organism
THREADS=8

## We need to check if the species provided by user is part of this list ==> throw error
SPECIES_LIST=(
    Acinetobacter_baumannii
    Burkholderia_cepacia
    Burkholderia_pseudomallei
    Campylobacter
    Clostridioides_difficile
    Enterococcus_faecalis
    Enterococcus_faecium
    Escherichia
    Klebsiella_oxytoca
    Klebsiella_pneumoniae
    Neisseria_gonorrhoeae
    Neisseria_meningitidis
    Pseudomonas_aeruginosa
    Salmonella
    Staphylococcus_aureus
    Staphylococcus_pseudintermedius
    Streptococcus_agalactiae
    Streptococcus_pneumoniae
    Streptococcus_pyogenes
    Vibrio_cholerae
)

for file in $INPUT_FOLDER/*.fna; do
    f=$(basename $file)
    echo "Processing ${f%.fna}"

    ## Run amrfinder
    amrfinder -n $file \
        --organism $ORGANISM \
        --threads $THREADS \
        --output $OUTPUT_FOLDER/${f%.fna}.amrfinder.out \
        --report_common \
        --plus \
        --name ${f%.fna} \
        --mutation_all $OUTPUT_FOLDER/${f%.fna}.mutations.txt

done

## Mutation results

mkdir -p amrfinder_Results

# concatenate mutation results (remove headers)
header_written=false
for file in AMRFinder_Out/*.mutations.txt; do
  if [ "$header_written" = false ]; then
    head -n 1 "$file" > amrfinder_Results/mutation_amrfinder.txt
    header_written=true
  fi
  tail -n +2 "$file" >> amrfinder_Results/mutation_amrfinder.txt
done

# concatenate ARG results
header_written=false
for file in AMRFinder_Out/*.amrfinder.out; do
  if [ "$header_written" = false ]; then
    head -n 1 "$file" > amrfinder_Results/final_amrfinder.txt
    header_written=true
  fi
  tail -n +2 "$file" >> amrfinder_Results/final_amrfinder.txt
done


### awk version
#awk 'FNR==1 && NR!=1 {next;}{print}' AMRFinder_Out/*.mutations.txt > amrfinder_Results/mutation_amrfinder.txt

#awk 'FNR==1 && NR!=1 {next;}{print}' AMRFinder_Out/*.amrfinder.out > amrfinder_Results/final_amrfinder.txt

  

  