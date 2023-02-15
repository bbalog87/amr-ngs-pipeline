# AQUAMIS Process Documentation
## Introduction
This documentation provides a step-by-step guide on how to install and set up [AQUAMIS](https://gitlab.com/bfr_bioinformatics/AQUAMIS) (Antibiotic Resistance QUAlity control for Metagenomic data using Kraken2, tAxonKit, and MASH), a workflow that performs quality control of metagenomic data prior to performing antibiotic resistance genes identification


## Prerequisites

  - A Linux environment
  - Conda or Mamba package manager
   - AQUAMIS installed in a Conda environment
  - Git installed in the Linux environment


# Installation

1. Clone the AQUAMIS repository from the GitLab repository:
   ```bash
   git clone https://gitlab.com/bfr_bioinformatics/AQUAMIS.git && cd AQUAMIS 
   ```
2. Create a Conda environment for AQUAMIS:
```bash 
mamba create -n aquamis_Env -c conda-forge -c bioconda aquamis -y 
```
