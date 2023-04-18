# Testing AMR analysis pipeline 


## amrFlow Pipeline

This pipeline is designed to analyze NGS (Illumina PE) antimicrobial resistance (AMR) in bacterial genomes using Nextflow, a workflow management system. The pipeline checks if the required software tools are installed and clones the AMR NGS Pipeline repository from Github if it does not already exist. The pipeline then sets up the working environment by creating the installation directory if it does not exist, downloading the Miniconda3 installer, checking if Miniconda3 is already installed, and installing it if it is not. It also creates a new Conda environment and installs the required packages for each process. Finally, the pipeline sets up the config file based on the paramerters proved by users, and create the species-specific script (job) which is ran using the Nextflow with the specified reads path and organism name.

## Prerequisites

The following software tools are required to run the pipeline:
- Laptop/computrer with at least 16 GB RAM, optimally 32 GB
- Sufficient disc storage (> 50 GB free disc space)
- Linux system (Tested with Ubuntu Debian 22.04 and Linux Mint V2.21)
- Run locally on your laptop/Workstation


## Installation

No active installation is required. The ```amrFlow_setup.sh``` script handles the installation of dependencies and workflow environments automatically.

This Bash script is used for setting up the system to running the antimicrobial resistance (AMR)
analysis pipeline. 
 - The setup script needs to be executed for each species to create the specific paramaters for that organism.
 - Howver, the subsquent setup will be more light and faster since the syetem will already have the required tools and packages.
 - If the reads path, organism name, and MLST scheme are not provided, an error message is displayed. It also checks if the provided organism name 
   is in the valid species list of supported organisms (mainly GLASS priority pathogens).

To run the pipeline, follow these steps:



## Usage

To use the pipeline, run the following command:

```
bash amrFlow_setup.sh -h
```

The following command line paramaters are displayed:

- `-r` or `--reads`: Path to the directory containing the sequencing reads (REQUIRED)
- `-o` or `--organism`: Name of the bacterial species (REQUIRED)
- `-s` or `--mlst`: MLST scheme for your species (REQUIRED)
- `-h` or `--help`: Display help message and exit

### Example
- Download the test dataset for each organism.
- Move them into a place easily accesible (e.g. Home directory).
- Open a terminal and move into the folder ```cd EcoliReads```, and type ```gunzip * ```to decompress the reads files.
- Copy the setup_script ```amrFlow_setup.sh``` somewhere easily accesible on your computer (e.g. $HOME).


To run the pipeline on sequencing reads in the directory `~/EcoliReads`, for the bacterial species `Escherichia` using the `ecoli` MLST scheme, run the following command:

```
bash amrFlow_setup.sh  -r ~/EcoliReads -o Escherichia -s ecoli

```
If sucessfull, this script will crreate the Nextflow script in ```~/amrFlow/Escherichia.sh```, which can be executed with

```
bash ~/amrFlow/Escherichia.sh

```


The supported MLST scheme are provided [HERE](https://github.com/bbalog87/amr-ngs-pipeline/blob/main/markdown/mlst_sheme.md)

## Supported species

The pipeline supports the following bacterial species:

- Acinetobacter_baumannii
- Burkholderia_cepacia
- Burkholderia_pseudomallei
- Campylobacter
- Clostridioides_difficile
- Enterococcus_faecalis
- Enterococcus_faecium
- Escherichia
- Klebsiella_oxytoca
- Klebsiella_pneumoniae
- Neisseria_gonorrhoeae
- Neisseria_meningitidis
- Pseudomonas_aeruginosa
- Salmonella
- Staphylococcus_aureus
- Staphylococcus_pseudintermedius
- Streptococcus_agalactiae
- Streptococcus_pneumoniae
- Streptococcus_pyogenes
- Vibrio_cholerae


## Test Scenario

1. Download the provided test datasets. Note that, only the NCBI naming format is currently supported.

| **Sample naming mode** |                            **Patterns**                                                                                        |
|------------------------|-----------------------------------------------------------------------------------------------------|
| NCBI                   | SampleID_ReadNumber.fastq. Example: Sample1_R1.fastq and Sample1_R2.fastq                                                 |
| FLEX                   | Any pattern that is neither NCBI nor Illumina. example : Sample1_NovaSeq_S1_L001_i7_index1_R1.fastq |
| ILLUMINA               | SampleID_Lane_Index_ReadNumber.fastq  Example: Sample1_001_ATCGTA_L001_R1.fastq                     |


## Test dataset

The test dataset include Illumina piared-sequencing data for the following three bacterial species:

| Bacterial Species     | organism name                            | MLST Scheme                                          |
|-----------------------|----------------------------------------------|------------------------------------------------------|
| [Escherichia coli](https://drive.google.com/drive/folders/1Ni-8eZ1VAL24pdgJOlFB_X40XRtt97rK?usp=sharing)      | Escherichia  | ecoli |
| [Staphylococcus aureus](https://drive.google.com/drive/folders/141WhmV-o7y6C07NmcFqMwDqzsvByhJ-_?usp=sharing) | Staphylococcus_aureus| saureus |
| [Acinetobacter baumannii](https://drive.google.com/drive/folders/1Ksho6GyUPcm9ssx5zaOcF3MXtlG2PYjB?usp=sharing) | Acinetobacter_baumannii | abaumannii_2 |


2. Open a terminal window and run the ```amrFlow_setup.sh``` script with no parameters to see the required inputs.

![ray-so-export(3)](https://user-images.githubusercontent.com/37578252/232752731-397f7673-464b-4d10-ba71-464b4d046405.png)

2. For Acinetobacter_baumannii, the command will be as follow
```
bash amrFlow_setup.sh --reads AcinetobacterReads  --organism Acinetobacter_baumannii --mlst abaumannii_2
```
This will launch the setup script on your system.
   
![ray-so-export(4)](https://user-images.githubusercontent.com/37578252/232754856-0701e66c-f24a-408b-bbf6-f80ff7d93c3c.png)
Since my system was already setup with this species (```Acinetobacter_baumannii```), some setup steps are skipped with a notification.
The first time you run this script, all required databases will be downloaded. The whole setup process takes **around 25 min to complete*. 

Once the setup is successfully complete without errors, you should see this message in the terminal


![ray-so-export(5)](https://user-images.githubusercontent.com/37578252/232757401-ccaa09e8-a9b7-42a6-95de-fdc590934bb6.png)

3. Copy and paste the the command ```bash /home/nguinkal/amrFlow/Acinetobacter_baumannii.sh``` in your terminal, then press ENTER.

If everything works fine, you should see a simimar ouput: 

![ray-so-export(6)](https://user-images.githubusercontent.com/37578252/232759602-f8ce4c83-ec31-42af-a318-ce178729ffae.png)


4. If no errors occur, and the pipeline compolete sucessfully, you should see this final message:

![ray-so-export(7)](https://user-images.githubusercontent.com/37578252/232760053-4bc0fb02-d561-4361-a265-233d5792103a.png)

**On my computer, the maximum running time for each species was ~30 min including the setup**

**NOTE**: you may run your own larger dataset (overnight), if the provided sample data run without errors on your system.
However, I tested the pipeline only for up to 22 samples in a single run. Your RAM might be limited for too large datasets.
