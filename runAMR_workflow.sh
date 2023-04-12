#!/bin/bash

# This is a Bash script for setting up and running the antimicrobial resistance (AMR) analysis pipeline:
# It checks if the required software tools are installed and clones the AMR NGS Pipeline repository from Github 
# if it does not already exist.
# The automated Nextflow pipeline is run with specified reads path and organism name.

# Set variables

#ANACONDA_URL="https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh"
#ANACONDA_FILENAME="$INSTALL_DIR/anaconda3.sh"

CURRENT_TIME=$(date +"%Y-%m-%d %T")
INSTALL_DIR="$HOME/AMRFLOW"
PIPELINE_DIR="$INSTALL_DIR/amr-ngs-pipeline"
ORGANISM_NAME=""
MLST_SCHEME=""
READS_PATH=""

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh"
MINICONDA_FILENAME="$INSTALL_DIR/miniconda3.sh"
ENV_NAME="amrFlow"
PYTHON_VERS="3.9"

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
	\nPlease provide these arguments using --reads, --mlst, and --organism options.\n Use --help or -h option to see the help message. \033[0m"
   
   exit 1
fi


# Print a formatted message to the console
#echo -e "\n\033[1m\033[92m ======= $CURRENT_TIME. STEP 0: SETTING UP YOUR WORKING ENVIRONMENT...======= \033[0m\n"
printf "\n\033[1m\033[92m ======= %s. STEP 0: SETTING UP YOUR WORKING ENVIRONMENT...======= \033[0m\n\n" "$CURRENT_TIME"


# Create the installation directory if it does not exist
if [[ ! -d "$INSTALL_DIR" ]]; then
  mkdir "$INSTALL_DIR"
   else
    echo "Directory already exists: $INSTALL_DIR"
   # return 1
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
    source "$HOME/.bashrc"
    echo "Miniconda3 has been exported to PATH."
  fi
fi

source "$INSTALL_DIR/Miniconda3/bin/activate" 


## install mamba
conda create -n amrFlow  -c conda-forge python=3.9 mamba -y
conda activate amrFlow


# install nextflow
 mamba install -c bioconda nextflow -y

 # Install git using mamba
 mamba install -c anaconda git -y


# Clone the AMR-NGS Pipeline repository if it does not already exist
if [[ -d "$PIPELINE_DIR" ]]; then
  echo "AMR-NGS Pipeline is already installed in $PIPELINE_DIR."
else
  git clone https://github.com/bbalog87/amr-ngs-pipeline.git "$PIPELINE_DIR"
  echo "AMR NGS Pipeline has been installed in $PIPELINE_DIR."
fi

#### Intall environments for each process.

mamba env create  --file $PIPELINE_DIR/workflow/conda/amrfinder.yml -p $INSTALL_DIR/Miniconda3/envs/amrfinder
mamba env create --file $PIPELINE_DIR/workflow/conda/aquamis.yml -p $INSTALL_DIR/Miniconda3/envs/aquamis
mamba env create --file $PIPELINE_DIR/workflow/conda/fastqc.yml -p $INSTALL_DIR/Miniconda3/envs/fastqc
mamba env create --file $PIPELINE_DIR/workflow/conda/staramr.yml -p $INSTALL_DIR/Miniconda3/envs/staramr
mamba env create  --file $PIPELINE_DIR/workflow/conda/tormes.yml -p $INSTALL_DIR/Miniconda3/envs/tormes


### SET-UP AQUAMIS

# Clone AQUAMIS repository
cd $INSTALL_DIR

if [ -d "AQUAMIS" ]; then
  echo "AQUAMIS directory exists, deleting..."
  rm -rf AQUAMIS
fi

echo "Cloning AQUAMIS repository..."
git clone https://gitlab.com/bfr_bioinformatics/AQUAMIS.git
cd AQUAMIS



# Activate AQUAMIS environment

conda activate $INSTALL_DIR/Miniconda3/envs/aquamis
mamba install -c bioconda busco augustus mamba -y

# Install and setup databases
bash scripts/aquamis_setup.sh -d
cd ..


## TORMES SET-UP

# Activate TORMES environment
conda activate $INSTALL_DIR/Miniconda3/envs/tormes

cd $INSTALL_DIR && tormes-setup


# Success message after installation is complete
echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"): SETUP COMPLETED ======= \033[0m\n"


echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"). STEP 1: PERFORMING AMR ANALYSIS WITH "$ORGANISM_NAME"...======= \033[0m\n"


  #=============  HERE will run the nextflow processes !!!=================
#cd $PIPELINE_DIR
# Run the pipeline with the specified reads path and organism name


nextflow run $PIPELINE_DIR/workflow/main.nf \
    --reads "$READS_PATH" \
    --organism "$ORGANISM_NAME" \
    --myConda "$INSTALL_DIR/Miniconda3/envs" \
    --scheme $MLST_SCHEME
	

# ======================================================================


# Print this only when Nextflow Run is sucessfully completed for all samples

echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"): AMR ANALYSIS COMPLETED... ======= \033[0m\n"
