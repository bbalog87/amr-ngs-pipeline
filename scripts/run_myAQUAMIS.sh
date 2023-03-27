#!/bin/bash
### samplesheet for AQUAMIS
WordDir=/home/nguinkal/AMR-Workflows/AQUAMIS_output/
/home/nguinkal/AMR-Workflows/AQUAMIS_output
create_sampleSheet.sh --mode ncbi \
                      --fastxDir ~/AMR-Workflows/TestData-reads \
                      --outDir $WordDir \
                      --force 

aquamis -l $WorkDir/sample.tsv \
        --taxlevel_qc s \
        -d $WorkDir \
        --min_trimmed_length 21 \
        --assembler shovill \
        --threads_sample  8 \
        --no_assembly 
         --logdir .
