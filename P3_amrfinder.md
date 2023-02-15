
# AMRFinder Workflow process P3.2

This script installs and runs the `amrfinderplus` tool from NCBI's Antimicrobial Resistance (AMR) GeneFinder package. It first creates a dedicated environment to install the tool and its dependencies using the `mamba` package manager, then downloads the latest AMR database.

The script processes input files from the TORMES Out/annotation directory, performs AMR detection on the input sequences, and outputs the results to the AMRFinder_Out directory. The results are also consolidated into two files in the amrfinder_Results directory.

## Installation

Install `amrfinderplus` using `mamba` in a dedicated environment:

```bash
mamba create -y -c bioconda -c conda-forge -n amrfinder_Env ncbi-amrfinderplus
```

After installation, activate the amrfinder conda environment using the following command:

```conda activate amrfinder_Env```
