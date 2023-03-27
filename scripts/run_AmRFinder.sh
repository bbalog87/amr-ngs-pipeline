#!/bin/bash
#set -e

## Install amrfinderplus using bioconda in a dedicated environment
## Find more here https://github.com/ncbi/amr/wiki/Install-with-bioconda
## Note: use mamba instead of conda

mamba create -y -c bioconda -c conda-forge -n amrfinder_Env ncbi-amrfinderplus ## run this only once

## activate amarfinder conda environment
conda activate amrfinder_Env

# Downlaod latest amrfinder database

amrfinder -u


# Set TORMES_Output path and create amrfinderINPUT directory
TORMES_ANNO=/home/nguinkal/AMR-Workflows/TORMES_Out/annotation ## The ouput of TORMES in Process P3.

## create this output as default, otherwise create the user-specified output folder (--output)
mkdir -p amrfinderINPUT

mkdir -p amrfinderINPUT && find $TORMES_ANNO/ \
-type f \( -name "*.faa" -o -name "*.gff" -o -name "*.fna" \) -exec cp {} amrfinderINPUT/ \;

## make all files excutable in amrfinderINPUT
chmod +rwx amrfinderINPUT/*


## We need to check if the species provided by user is part of this list ==> throw error
SPECIES_LIST=(Acinetobacter_baumannii Burkholderia_cepacia \
Burkholderia_pseudomallei Campylobacter Clostridioides_difficile \
Enterococcus_faecalis Enterococcus_faecium Escherichia Klebsiella_oxytoca \
Klebsiella_pneumoniae Neisseria_gonorrhoeae Neisseria_meningitidis \
Pseudomonas_aeruginosa Salmonella Staphylococcus_aureus \
Staphylococcus_pseudintermedius Streptococcus_agalactiae \
Streptococcus_pneumoniae Streptococcus_pyogenes Vibrio_cholerae)

## The default output folder or the user-specified output folder
mkdir -p AMRFinder_Out
INPUT_FOLDER="amrfinderINPUT" # default input
OUTDIR="AMRFinder_Out" ## default output folder
THREADS=8
ORGANISM="Staphylococcus_aureus" ## default organism

for file in ${INPUT_FOLDER}/*.fna

do

f=$(basename $file)
 echo " Processing ${f%.fna}"
   
amrfinder -n $file \
          #-p ${file%.fna}.faa \
		 # -p ${file%.fna}.faa
         --organism Staphylococcus_aureus\
	 	  --threads 8 \
		  --output AMRFinder_Out/${f%.fna}.amrfinder.out  \
		  --report_common --plus \
		  --name ${f%.fna} \
		  --mutation_all AMRFinder_Out/${f%.fna}.mutations.txt


#done 

### Mutation results

mkdir -p amrfinder_Results

for file in AMRFinder_Out/*.mutations.txt
do
  if [ ! -f mutation_amrfinder.txt ]  # concatenate output results (remove headers)
  then
    head -n 1 "$file" > amrfinder_Results/mutation_amrfinder.txt
  fi
  tail -n +2 "$file" >> amrfinder_Results/mutation_amrfinder.txt
done

## ARG results
for file in AMRFinder_Out/*.amrfinder.out
do
  if [ ! -f final_amrfinder.txt ]
  then
    head -n 1 "$file" > amrfinder_Results/final_amrfinder.txt ## concatenated results
  fi
  tail -n +2 "$file" >> amrfinder_Results/final_amrfinder.txt
done

  

  