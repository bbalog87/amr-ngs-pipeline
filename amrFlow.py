#!/usr/bin/env python3

import argparse
import os
import sys
import datetime

# The supported species list
SPECIES_LIST = [
    'Acinetobacter_baumannii',
    'Burkholderia_cepacia',
    'Burkholderia_pseudomallei',
    'Campylobacter',
    'Clostridioides_difficile',
    'Enterococcus_faecalis',
    'Enterococcus_faecium',
    'Escherichia',
    'Klebsiella_oxytoca',
    'Klebsiella_pneumoniae',
    'Neisseria_gonorrhoeae',
    'Neisseria_meningitidis',
    'Pseudomonas_aeruginosa',
    'Salmonella',
    'Staphylococcus_aureus',
    'Staphylococcus_pseudintermedius',
    'Streptococcus_agalactiae',
    'Streptococcus_pneumoniae',
    'Streptococcus_pyogenes',
    'Vibrio_cholerae'
]

DEFAULT_WORK_DIR = os.path.join(os.path.expanduser("~"), "amrFlow")

# Parse command line arguments
parser = argparse.ArgumentParser(description='Run amrFlow pipeline using Nextflow.')
parser.add_argument('--reads', metavar='PATH', required=False, help='Path to folder containing FASTQ files')
parser.add_argument('--organism', metavar='NAME', required=False, help='Name of the organism to analyze')
parser.add_argument('--mlst', metavar='SCHEME', required=False, help='Name of the MLST scheme to use')
parser.add_argument('--myConda', metavar='PATH', required=False, help='Path to conda environment')

args = parser.parse_args()

# Check if reads path, organism name, MLST scheme, and conda environment are provided
if not all(vars(parser.parse_args()).values()):
    print('\033[1;31mERROR: Reads folder, organism name, MLST scheme, and conda environment are mandatory.\033[0m\n'
                 'Please provide these arguments using --reads, --organism, --mlst, and --myConda options.\n'
                 'Use --help or -h option to see the help message.\n'
                 'MLST schemes for selected species can be found here: \n'
                 '\033[34mhttps://github.com/bbalog87/amr-ngs-pipeline/blob/main/markdown/mlst_sheme.md \033[0m')
    #parser.print_help()
    sys.exit(1)

# Check if the provided organism name is in the valid species list
if args.organism not in SPECIES_LIST:
    print(f"ERROR: Organism '{args.organism}' not currently supported.")
    print("THE SUPPORTED ORGANISMS ARE:")
    for species in SPECIES_LIST:
        print(species)
    exit(1)

# Create Nextflow command
command = (f"nextflow run AMRFLOW2/amr-ngs-pipeline/workflow/main.nf "
           f"--reads {args.reads} --organism {args.organism} --myConda {args.myConda} --scheme {args.mlst}")

now = datetime.datetime.now()
current_time = now.strftime("%Y-%m-%d %H:%M:%S")

message = (f"nextflow run amrFlow/amr-ngs-pipeline/workflow/main.nf "
           f"--reads {args.reads} --organism {args.organism} --myConda {args.myConda} --scheme {args.mlst}")


#print(f"nextflow run AMRFLOW2/amr-ngs-pipeline/workflow/main.nf "
     # f"--reads {args.reads} --organism {args.organism} --myConda {args.myConda} --scheme {args.mlst}")
print(f"INFO: {current_time} - {message}")

# Execute Nextflow command
os.system(command)


