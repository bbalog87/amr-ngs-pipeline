#!/bin/bash
#============================================================================================
# This script is a Bash script for setting up and running the antimicrobial resistance (AMR)
# analysis pipeline. It checks if the required software tools are installed and clones the
# AMR NGS Pipeline repository from Github if it does not already exist. 
# The automated Nextflow pipeline is run with the specified reads path and organism name.
# The script defines several variables such as the current time, the installation directory, 
# the organism name, the MLST scheme, and the reads path. It also defines a function to print
# help and parses the command line arguments. If the reads path, organism name, and MLST scheme 
# are not provided, an error message is displayed. It also checks if the provided organism name 
# is in the valid species list.
# The script then sets up the working environment by creating the installation directory 
# if it does not exist, downloading the Miniconda3 installer, checking if Miniconda3 is already 
# installed, and installing it if it is not. It also creates a new Conda environment and installs 
# the required packages. Finally, the script clones the AMR NGS Pipeline repository from Github, 
# sets up the config file, and runs the Nextflow pipeline with the specified reads path and organism name.
#========================================================================================================

# Set variables

#ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh"
#ANACONDA_FILENAME="$INSTALL_DIR/anaconda3.sh"

CURRENT_TIME=$(date +"%Y-%m-%d %T")
INSTALL_DIR="$HOME/amrFlow"
PIPELINE_DIR="$INSTALL_DIR/amr-ngs-pipeline"
ORGANISM_NAME=""
MLST_SCHEME=""
READS_PATH=""

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh"
MINICONDA_FILENAME="$INSTALL_DIR/miniconda3.sh"
ENV_NAME="amrFlow"
PYTHON_VERS="3.9"

# The supported species list
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




# Function to print help
print_help() {
  echo -e "\n\033[1m\033[91m ======= HELP ======= \033[0m\n"
  echo "Usage: bash runAMR_workflow.sh [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -r, --reads <path/to/reads>        Path to the directory containing the sequencing reads (REQUIRED)"
  echo "  -o, --organism <organism_name>     Name of the bacterial species (REQUIRED)"
  echo "  -s, --mlst <organism_name>          MLST scheme for your species (REQUIRED)"
  echo "  -h, --help                         Display this help and exit"
  echo ""
}


# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) print_help; exit 0 ;;
        -r|--reads) READS_PATH="$2"; shift ;;
        -o|--organism) ORGANISM_NAME="$2"; shift ;;
        -s|--mlst) MLST_SCHEME="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if reads path and organism name are provided
if [[ -z $READS_PATH || -z $ORGANISM_NAME || -z $MLST_SCHEME ]]; then
    echo -e "\033[1m\033[91m ERROR: Reads folder, organism name, and MLST scheme are mandatory.
	\nPlease provide these arguments using --reads, --mlst, and --organism options.\n Use --help or -h option to see the help message.
	MSLT_scheme for selected species can be found here: https://github.com/bbalog87/amr-ngs-pipeline/blob/main/markdown/mlst_sheme.md\033[0m"
   
   exit 1
fi


# Check if the provided organism name is in the valid species list
if ! printf '%s\n' "${SPECIES_LIST[@]}" | grep -qx "$ORGANISM_NAME"; then
    echo -e "\033[1m\033[31mERROR: Organism '$ORGANISM_NAME' not currently supported.\033[0m"
    echo -e "\033[1m\033[38;2;0;128;0mTHE SUPPORTED ORGANISMS ARE:\033[0m"
    printf '\033[32m%s\033[0m\n' "${SPECIES_LIST[@]}"
    exit 1
fi




# Print a formatted message to the console
#echo -e "\n\033[1m\033[92m ======= $CURRENT_TIME. STEP 0: SETTING UP YOUR WORKING ENVIRONMENT...======= \033[0m\n"
printf "\n\033[1m\033[92m ======= %s.SETTING UP YOUR WORKING ENVIRONMENT...======= \033[0m\n\n" "$CURRENT_TIME"


# Create the installation directory if it does not exist
if [[ ! -d "$INSTALL_DIR" ]]; then
  mkdir "$INSTALL_DIR"
   else
    echo "Directory already exists: $INSTALL_DIR"
fi


# Check if Miniconda3 is already installed in the specified directory
if [[ -d $INSTALL_DIR/Miniconda3 ]]; then
  echo "Miniconda3 is already installed in $INSTALL_DIR/Miniconda3."
else
  # Download the Miniconda3 installer to the specified directory
  wget "$MINICONDA_URL" -O "$MINICONDA_FILENAME"
  chmod +x "$MINICONDA_FILENAME"
  # Install Miniconda3 silently
  bash "$MINICONDA_FILENAME" -b -p "$INSTALL_DIR/Miniconda3"
  echo "Miniconda3 has been installed in $INSTALL_DIR/Miniconda3."
  
  # Add Miniconda3 to PATH if it is not already included
  if [[ $PATH == *"$INSTALL_DIR/Miniconda3/bin"* ]]; then
    echo "Miniconda3 is already exported to PATH."
  else
    echo "export PATH=\"$INSTALL_DIR/Miniconda3/bin:\$PATH\"" >> "$HOME/.bashrc"
    source ~/.bashrc
    echo "Miniconda3 has been exported to PATH."
  fi
fi




#source "$INSTALL_DIR/Miniconda3/bin/activate"
#source "$HOME/.bashrc"


## install mamba
#conda create -n "$ENV_NAME"  -c conda-forge python=3.9 mamba -y
conda activate "$ENV_NAME"


# install nextflow
 mamba install -c bioconda nextflow -y 

 # Install git 
 #mamba install -c anaconda git -y

# Clone the AMR-NGS Pipeline repository if it does not already exist
if [[ -d "$PIPELINE_DIR" ]]; then
  echo "AMR-NGS Pipeline is already installed in $PIPELINE_DIR."
else
  git clone https://github.com/bbalog87/amr-ngs-pipeline.git "$PIPELINE_DIR"
  echo "AMR NGS Pipeline has been installed in $PIPELINE_DIR."
fi

#### Intall environments for each process.

mamba env create  --file $PIPELINE_DIR/workflow/conda/amrfinder.yml -p $INSTALL_DIR/Miniconda3/envs/amrfinder
mamba create -y -c conda-forge -c bioconda -n amrfinder ncbi-amrfinderplus
mamba env create --file $PIPELINE_DIR/workflow/conda/aquamis.yml -p $INSTALL_DIR/Miniconda3/envs/aquamis
mamba env create --file $PIPELINE_DIR/workflow/conda/fastqc.yml -p $INSTALL_DIR/Miniconda3/envs/fastqc
mamba env create --file $PIPELINE_DIR/workflow/conda/staramr.yml -p $INSTALL_DIR/Miniconda3/envs/staramr
mamba env create  --file $PIPELINE_DIR/workflow/conda/tormes.yml -p $INSTALL_DIR/Miniconda3/envs/tormes





### SET-UP AQUAMIS

# Clone AQUAMIS repository

cd $INSTALL_DIR
echo "Setting up AQUAMIS repository..."

if [ -d "AQUAMIS" ]; then
  echo "AQUAMIS directory exists, checking databases..."

else 
  echo "AQUAMIS directory does not exist"
  echo "Cloning AQUAMIS repository..."
  git clone https://gitlab.com/bfr_bioinformatics/AQUAMIS.git
fi



# Activate AQUAMIS environment

#conda activate $INSTALL_DIR/Miniconda3/envs/aquamis
mamba install -c bioconda busco augustus mamba -y

# Install and setup databases
cd AQUAMIS
if [ ! -d "$INSTALL_DIR/AQUAMIS/reference_db/mash" ] || \
   [ -z "$(ls -A $INSTALL_DIR/AQUAMIS/reference_db)" ]; then
    bash scripts/aquamis_setup.sh -d
fi
cd ..



## TORMES SET-UP

# Activate TORMES environment
conda activate $INSTALL_DIR/Miniconda3/envs/tormes

cd $INSTALL_DIR && tormes-setup


# Download latest amrfinder database

conda activate $INSTALL_DIR/Miniconda3/envs/amrfinder

 amrfinder -U


# Success message after installation is complete
echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"): SETUP COMPLETED ======= \033[0m\n"


echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"). STEP 1: PERFORMING AMR ANALYSIS WITH "$ORGANISM_NAME"...======= \033[0m\n"


  #=============  HERE will run the nextflow processes !!!=================

# Run the pipeline with the specified reads path and organism name




source "$INSTALL_DIR/Miniconda3/bin/activate" 
#$INSTALL_DIR/Miniconda3/envs
#source $INSTALL_DIR/Miniconda3/etc/profile.d/conda.sh



#conda activate "$ENV_NAME"
 nextflow run $PIPELINE_DIR/workflow/main.nf \
    --reads "$READS_PATH" \
    --organism "$ORGANISM_NAME" \
    --myConda "$INSTALL_DIR/Miniconda3/envs" \
    --scheme $MLST_SCHEME
	

# ======================================================================


# Print this only when Nextflow Run is sucessfully completed for all samples

echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"): AMR ANALYSIS COMPLETED... ======= \033[0m\n"