
# AMRFinder process P3.2 Documentation

This script installs and runs the `amrfinderplus` tool from [NCBI's Antimicrobial Resistance (AMR) GeneFinder package](https://github.com/ncbi/amr/wiki). It first creates a dedicated environment to install the tool and its dependencies using the `mamba` package manager, then downloads the latest AMR database.

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


The input files should be in FASTA format, with file extensions ".fna", ".faa", or ".gff". 

## Arguments

The following arguments are used in the script:
```
- `-n`: input file in FASTA format
- `--organism`: organism to use for searching the AMRfinderplus database. This should be one of the following:
Acinetobacter_baumannii, Burkholderia_cepacia, Burkholderia_pseudomallei, Campylobacter, Clostridioides_difficile, 
Enterococcus_faecalis, Enterococcus_faecium, Escherichia, Klebsiella_oxytoca,
Klebsiella_pneumoniae, Neisseria_gonorrhoeae, Neisseria_meningitidis, 
Pseudomonas_aeruginosa, Salmonella, Staphylococcus_aureus, Staphylococcus_pseudintermedius, 
Streptococcus_agalactiae, Streptococcus_pneumoniae, or Vibrio_cholerae
- `--threads`: number of threads to use (default: 8)
- `--output`: output directory (default: "AMRFinder_Out")
- `--name`: name of output file (default: same as input file)
- `--mutation_all`: output file for mutations found (default: "AMRFinder_Out/${f%.fna}.mutations.txt")
- `--report_common`: report ARGs that are found commonly in the selected organism
- `--plus`: report additional information on ARGs, such as mutations and variants


```

The organism and threads used for AMRFinder analysis are set using the following commands:

```bash

ORGANISM="Staphylococcus_aureus" ## default organism
THREADS=8
```

## Example Usage when running in the nextflow workflow 

The following options are available:

 -   --input: Input directory for genome sequences in FASTA format (default: amrfinderINPUT).
-    --output: Output directory for AMR detection results (default: AMRFinder_Out).
-    --organism: Organism name for AMR detection (default: Staphylococcus_aureus).
-    --threads: Number of threads to use (default: 8).

## Running AMRFinder

AMRFinder is run for each input file using the following command:

```python
amrfinder -n $file \
          --organism Staphylococcus_aureus \
          --threads 8 \
          --output AMRFinder_Out/${f%.fna}.amrfinder.out  \
          --report_common --plus \
          --name ${f%.fna} \
          --mutation_all AMRFinder_Out/${f%.fna}.mutations.txt

```

## Concatenated Results and Final Output

The script produces two output files: 

1. **Mutation output**: A file named "mutation_amrfinder.txt" is created in a directory named "amrfinder_Results". This file contains information about mutations found in the input files. If the file already exists, the script appends the results to the end of the file.

2. **ARG output**: A file named "final_amrfinder.txt" is created in the "amrfinder_Results" directory. This file contains information about ARGs found in the input files.


The results from all the samples are stored in the `amrfinder_Results` directory in two files:
- `mutation_amrfinder.txt`: contains mutation results for all the samples.
- `final_amrfinder.txt`: contains ARG results for all the samples.

These files can be opened in a spreadsheet program such as Microsoft Excel or Google Sheets for further analysis.

## Conclusion

In this process, we installed `amrfinderplus` using bioconda in a dedicated environment, downloaded the latest `amrfinderplus` database, and ran it on a set of sample files in the `TORMES_Out/annotation` directory. The Process also included concatenating the results for all samples into two separate files. The resulting output files contain information about the ARGs and mutations present in the input files, which can be used to study antimicrobial resistance in the samples.

This process can be easily adapted for different sets of input files and customized based on the needs of the user.
Additionally, it can be modified to be run on a remote server or high-performance computing cluster to process large sets of input files.

## Script

Here's the full script:


```python
#!/bin/bash

# Install amrfinderplus using bioconda in a dedicated environment
# Find more here https://github.com/ncbi/amr/wiki/Install-with-bioconda
# Note: use mamba instead of conda

mamba create -y -c bioconda -c conda-forge -n amrfinder_Env ncbi-amrfinderplus # run this only once

# Activate amrfinder conda environment
conda activate amrfinder_Env

# Download latest amrfinder database
amrfinder -u

# Set TORMES_Output path and create amrfinderINPUT directory
TORMES_ANNO=/home/nguinkal/AMR-Workflows/TORMES_Out/annotation # The output of TORMES in Process P3.

# Create amrfinderINPUT directory and copy all files with extension .faa, .gff, .fna to it
# from the specified directory.
# If the user provides a different output directory with --output flag, it will be used instead.
mkdir -p amrfinderINPUT
find "$TORMES_ANNO"/ -type f \( -name "*.faa" -o -name "*.gff" -o -name "*.fna" \) -exec cp {} amrfinderINPUT/ \;

# Make all files executable in amrfinderINPUT
chmod +rwx amrfinderINPUT/*

# Check if the species provided by user is part of this list
SPECIES_LIST=(Acinetobacter_baumannii Burkholderia_cepacia \
Burkholderia_pseudomallei Campylobacter Clostridioides_difficile \
Enterococcus_faecalis Enterococcus_faecium Escherichia Klebsiella_oxytoca \
Klebsiella_pneumoniae Neisseria_gonorrhoeae Neisseria_meningitidis \
Pseudomonas_aeruginosa Salmonella Staphylococcus_aureus \
Staphylococcus_pseudintermedius Streptococcus_agalactiae \
Streptococcus_pneumoniae Streptococcus_pyogenes Vibrio_cholerae)

# Set default output folder, input folder, number of threads, and organism
mkdir -p AMRFinder_Out
INPUT_FOLDER="amrfinderINPUT" # default input
OUTDIR="AMRFinder_Out" # default output folder
THREADS=8
ORGANISM="Staphylococcus_aureus" # default organism

# Loop through all .fna files in the input folder, run amrfinder on each one, and output the results
for file in "${INPUT_FOLDER}"/*.fna; do
  f=$(basename "$file")
  echo "Processing ${f%.fna}"

  # Run amrfinder on the current file
  amrfinder -n "$file" \
            --organism "$ORGANISM" \
            --threads "$THREADS" \
            --output "${OUTDIR}/${f%.fna}.amrfinder.out" \
            --report_common --plus \
            --name "${f%.fna}" \
            --mutation_all "${OUTDIR}/${f%.fna}.mutations.txt"
done

# Create a directory for the mutation results
mkdir -p amrfinder_Results

# Concatenate all the mutation result files into a single file and save it in the mutation results directory


mkdir -p amrfinder_Results 

## Mutation results
awk 'FNR==1 && NR!=1 {next;}{print}' AMRFinder_Out/*.mutations.txt > amrfinder_Results/mutation_amrfinder.txt

# concatenate ARG results
awk 'FNR==1 && NR!=1 {next;}{print}' AMRFinder_Out/*.amrfinder.out > amrfinder_Results/final_amrfinder.txt

  ```




