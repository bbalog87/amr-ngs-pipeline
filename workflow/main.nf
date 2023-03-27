
process FASTQC {

    tag "${fq1}_XX_${fq2}"
    publishDir "${params.results}/fastqc/${id}"

    input:
    tuple val(id),path(fq1),path(fq2)

    output:
    path "*.html"
    path "*.zip"

    shell:
    '''
    fastqc -t!{task.cpus} !{fq1} !{fq2}
    
    '''
}

process AQUAMIS {

    tag "${fq1}_XX_${fq2}"
    publishDir "${params.results}/aquamis/${id}"

    input:
    tuple val(id),path(fq1),path(fq2)

    output:
    tuple val(id), path("Assembly/assembly/*.fasta")
    path "*"
    
    shell:
    
    '''
    create_sampleSheet.sh --mode ncbi \
                      --fastxDir . \
                      --outDir . \
                      --force 

    aquamis -l samples.tsv \
        --taxlevel_qc S \
        -d . \
        --min_trimmed_length 22 \
        --threads_sample !{task.cpus} \
        --logdir . \
        --kraken2db !{params.kraken} \
        --taxonkit_db !{params.taxonkit} \
        -m !{params.mash} \
        -r Testing_with_Staphylococcus
    '''
}

process TORMES {

    tag "${genome}"
    publishDir "${params.results}/tormes/${id}"

    input:
    tuple val(id), path(genome)

    output:
    tuple val(id), path("results/annotation/${id}_annotation/*.fna")
    path "*"

    shell:

    '''
    echo -e "Samples\tRead1\tRead2\tDescription" > sample_metadata.txt
    echo -e "!{id}\tGENOME\t!{genome}\t""This is the genome for !{id}" >> sample_metadata.txt
    tormes -m sample_metadata.txt -o results -t !{task.cpus}
    
    '''
}

process AMRFINDER {

    tag "${fna}"
    publishDir "${params.results}/amrfinder/${id}"

    input:
    tuple val(id), path(fna)

    output:
    path "*"

    shell:

    '''
    ORGANISM="Staphylococcus_aureus" 

    amrfinder -n !{fna} \
          --organism "$ORGANISM" \
          --threads !{task.cpus} \
          --output "!{id}.amrfinder.out" \
          --report_common --plus \
          --name !{id} \
          --mutation_all "!{id}.mutations.txt"
    
    '''
}

workflow{

    fastqc_files = Channel.fromFilePairs(params.fastqs, flat:true)

    FASTQC(fastqc_files)
    AQUAMIS(fastqc_files)
    TORMES(AQUAMIS.out[0])
    AMRFINDER(TORMES.out[0])
}