#/bin/bash

set -e


### samplesheet for AQUAMIS
#WorkDir=/home/nguinkal/AMR-Workflows/AQUAMIS_output2
#KRAKEN2DB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/kraken
#TAXONKITDB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/taxonkit
#MASHDB=/home/nguinkal/AQUAMIS/AQUAMIS/reference_db/mash/mashDB.msh
READS=/home/nguinkal/AMR-Workflows/TestData-reads 
GENOMES=/home/nguinkal/AMR-Workflows/AQUAMIS_output2/Assembly/assembly


#/home/nguinkal/AMR-Workflows/AQUAMI

#wget https://anaconda.org/nmquijada/tormes-1.3.0/2021.06.08.113021/download/tormes-1.3.0.yml



### install environment
#mamba env create -n tormes_Env --file tormes-1.3.0.yml

### Create metadata for reads
ls $READS/*_1* | sed "s/.*\///" | sed "s/_1.fastq//" > uno.tmp
for i in $(<uno.tmp); do realpath $READ/${i}_1.fastq >> dos.tmp; realpath $READ/${i}_2.fastq >> tres.tmp; done
for i in $(<uno.tmp); do echo "This is ${i}" >> cuatro.tmp; done
paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > myMetadataReads.txt
rm *tmp

## Create meta data for genome assmeblies

ls $GENOMES/*fasta | sed "s/.*\///" | sed "s/.fasta//" > uno.tmp
for i in $(<uno.tmp); do echo "GENOME" >> dos.tmp; realpath $GENOMES/${i}.fasta >> tres.tmp; done
for i in $(<uno.tmp); do echo "This is the genome for ${i}" >> cuatro.tmp; done
paste uno.tmp dos.tmp tres.tmp cuatro.tmp | sed "1iSamples\tRead1\tRead2\tDescription" > myMetadataGenomes.txt
rm *tmp


### Tormes parameters

META=/home/nguinkal/AMR-Workflows/myMetadataGenomes.txt
OUTDIR=TORMES_Out
THREADS=8

 ### Run Tormes now:
 
 tormes -m $META -o $OUTDIR -t $THREADS








