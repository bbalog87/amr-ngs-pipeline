#/bin/bash

set -e


### samplesheet for AQUAMIS
#WorkDir=/home/nguinkal/AMR-Workflows/AQUAMIS_output2
#KRAKEN2DB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/kraken
#TAXONKITDB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/taxonkit
#MASHDB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/mash/mashDB.msh
#READS=/home/nguinkal/AMR-Workflows/TestData-reads 









### install starAMR environment
#mamba create -c conda-forge -c bioconda -c defaults --name staramr_Env  staramr -y 

## activate environment
#mamba activate staramr_Env




### StarAMR parameters

GENOMES=/home/nguinkal/AMR-Workflows/AQUAMIS_output2/Assembly/assembly
OUTDIR=starAMR_Out
THREADS=8

 ### Run starAMR now:
 
staramr search $GENOMES/*.fasta --output-dir $OUTDIR --mlst-scheme saureus  --genome-size-lower-bound 2000000
		#-o $OUTDIR 
		   #--pointfinder-organism staphylococcus_aureus
				
