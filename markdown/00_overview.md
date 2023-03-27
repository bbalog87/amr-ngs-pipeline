# Workflow Overview

This workflow pipeline performs a series of bioinformatics analyses on input fastq files, which are assumed to be paired-end reads from bacterial genome sequencing. The pipeline uses four different tools (FastQC, AQUAMIS, TORMES, AMRFinder, and STARAMR) to perform quality control, genome assembly, annotation, and antibiotic resistance prediction.

## Tools Used

    FastQC: a tool for quality control of high-throughput sequence data.
    AQUAMIS: a tool for de novo genome assembly, quality control, and annotation.
    TORMES: a tool for annotating bacterial genomes using homology-based and ab initio methods.
    AMRFinder: a tool for predicting antibiotic resistance genes in bacterial genomes.
    STARAMR: a tool for detecting antibiotic resistance genes and mutations in bacterial genomes.

## Workflow Steps

    FastQC: The input fastq files are processed using FastQC to check for quality issues, such as sequence length distribution, GC content, and sequence duplication levels. FastQC generates an HTML report and a zip file containing the results.

    AQUAMIS: The preprocessed reads from step 1 are assembled using AQUAMIS, which uses a combination of de Bruijn graph-based and overlap-based assembly algorithms to generate a draft genome assembly. The assembly is then evaluated for quality and completeness using various metrics, such as N50 and BUSCO scores. AQUAMIS also performs gene prediction and functional annotation of the genome.

    TORMES: The annotated genome from step 2 is further annotated using TORMES, which uses homology-based and ab initio methods to predict genes, functional domains, and noncoding RNAs. TORMES also predicts bacterial virulence factors and prophage regions.

    AMRFinder: The genome assembly from step 2 is analyzed for antibiotic resistance genes using AMRFinder. The tool identifies potential resistance genes and mutations in the genome, and generates a report in tabular format.

    STARAMR: The genome assembly from step 2 is analyzed for antibiotic resistance genes and mutations using STARAMR. The tool uses a combination of BLAST and MLST-based methods to identify resistance genes and mutations, and generates a report in tabular format.

## Workflow Inputs

The workflow takes in a directory containing paired-end fastq files, as well as various parameters for each of the tools used.

## Workflow Outputs

The workflow generates various output files for each tool, including HTML and zip files for FastQC, annotated genome assemblies for AQUAMIS and TORMES, and reports in tabular format for AMRFinder and STARAMR. These outputs are organized into separate directories for each tool and sample, as specified by the publishDir directive in each process.
## Workflow Dependencies

The pipeline requires several software tools and packages to be installed, including FastQC, AQUAMIS, TORMES, AMRFinder, and STARAMR, as well as various supporting libraries and dependencies.
