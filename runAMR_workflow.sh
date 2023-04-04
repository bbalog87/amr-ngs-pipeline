#!/bin/bash

# This is a Bash script for setting up and running the antimicrobial resistance (AMR) analysis pipeline:
# It checks if the required software tools are installed and clones the AMR NGS Pipeline repository from github 
# if it does not already exist.
# The automated Nextflow pipeline is run with specified reads path and organism name.



# Get the current date and time
CURRENT_TIME=$(date +"%Y-%m-%d %T")
# Specify the installation directory for Anaconda3
INSTALL_DIR="$HOME/AMR-WorkDir"
# Pipeline directory
PIPELINE_DIR="$INSTALL_DIR/amr-ngs-pipeline"

# Command line parameters
READS_DIR=""  # Path to NGS Illumina reads
ORGANISM_NAME="" ## binary speciesd anme of the sequenced pathogens (e.g. Escherichia coli)
MLST_SCHEME="" ## mlts scheme, e.g. ecoli


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
        #-h|--help) echo "Help message goes here"; exit 0;;
		-h|--help)    print_help; exit 0;;
		
        --reads|-r) READS_PATH="$2"; shift ;;
        --organism|-o) ORGANISM_NAME="$2"; shift ;;
		-mlst|-s) MLST_SCHEME="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check if reads path and organism name are provided
if [[ -z $READS_PATH || -z $ORGANISM_NAME || -z $MLST_SCHEME ]]; then
    echo -e "\033[1m\033[91m ERROR: Reads folder, organism name amd mlst scheme are mandatory. 
	\nPlease provide these arguments using --reads, --mlst and --organism options. 
	Use --help or -h option to see the help message. \033[0m"
    exit 1
fi


# Print a formatted message to the console
echo -e "\n\033[1m\033[92m ======= $CURRENT_TIME. STEP 0: SETTING UP YOUR WORKING ENVIRONMENT...======= \033[0m\n"



# Create the installation directory if it does not exist
if [[ ! -d "$INSTALL_DIR" ]]; then
  mkdir -p "$INSTALL_DIR"
fi


# Check if Anaconda3 is already installed in the specified directory
if [[ -d "$INSTALL_DIR/anaconda3" ]]; then
  echo "Anaconda3 is already installed in $INSTALL_DIR/anaconda3."
else
  # Download the Anaconda3 installer to the specified directory
  wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh -O $INSTALL_DIR/anaconda3.sh
  
  
  # Install Anaconda3 silently
  bash $INSTALL_DIR/anaconda3.sh -b -p $INSTALL_DIR/anaconda3
  echo "Anaconda3 has been installed in $INSTALL_DIR/anaconda3."
  
  
  # Add Anaconda to PATH
  if [[ $PATH == *"$INSTALL_DIR/anaconda3/bin"* ]]; then
    echo "Anaconda is already exported to PATH."
  else
    echo 'export PATH="$INSTALL_DIR/anaconda3/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    echo "Anaconda has been exported to PATH."
  fi
fi


# Check if mamba is already installed in the conda environment
if conda list mamba >/dev/null 2>&1; then
  echo "mamba is already installed."
else
  # Install mamba using conda
  conda install -c conda-forge mamba -y
fi

# Check if git is already installed in the conda environment
if conda list git >/dev/null 2>&1; then
  echo "git is already installed."
else
  # Install git using mamba
  mamba install -c anaconda git -y
fi


# Clone the AMR NGS Pipeline repository if it does not already exist
if [[ -d "$PIPELINE_DIR" ]]; then
  echo "AMR NGS Pipeline is already installed in $PIPELINE_DIR."
else
  git clone https://github.com/bbalog87/amr-ngs-pipeline.git "$PIPELINE_DIR"
  echo "AMR NGS Pipeline has been installed in $PIPELINE_DIR."
fi

# Success message after installation is complete
echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"): SETUP COMPLETED ======= \033[0m\n"


echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"). STEP 1: PERFORMING AMR ANALYSIS WITH "$ORGANISM_NAME"... ======= \033[0m\n"

#=============  HERE will run the nextflow processes !!!=================

# Run the pipeline with the specified reads path and organism name

nextflow run $PIPELINE_DIR/workflow/main.nf \
            --reads "$READS_PATH" \
			--organism "$ORGANISM_NAME" \
			--mlst-scheme "$MLST_SCHEME" -resume


# ======================================================================


# Print this only when Nextflow Run is sucessfully completed for all samples

echo -e "\n\033[1m\033[92m ======= $(date +"%Y-%m-%d %T"): AMR ANALYSIS COMPLETED... ======= \033[0m\n"

