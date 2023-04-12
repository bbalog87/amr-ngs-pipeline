
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

    tag "aquamis"
    publishDir "${params.results}/aquamis"

    input:
    path fastqs
    val organism

    output:
    path "Assembly/assembly/*.fasta"
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
        -r 'AMR Analysis with !{organism}'
    '''
}

process TORMES {


    tag "tormes"
    publishDir "${params.results}/tormes"

    input:
    path genomes

    output:
    path "results/annotation/*_annotation/*.fna"
    path "*"

    shell:

    '''
    echo -e "Samples\tRead1\tRead2\tDescription" > sample_metadata.txt

    for FILE in $(ls *.fasta);do echo -e "${FILE%.*}\tGENOME\t${FILE}\t""This is the genome for ${FILE%.*}" >> sample_metadata.txt;done
    tormes -m sample_metadata.txt -o results -t !{task.cpus}
    
    '''
}

process AMRFINDER {

    tag "${fna}"
    publishDir "${params.results}/amrfinder"

    input:
    tuple val(id), path(fna)
    val organism

    output:
    path "*"

    shell:

    '''

    amrfinder -n !{fna} \
          --organism !{organism} \
          --threads !{task.cpus} \
          --output "!{id}.amrfinder.out" \
          --report_common --plus \
          --name !{id} \
          --mutation_all "!{id}.mutations.txt"
    
    '''
}

process STARAMR {

    tag "staramr"
    publishDir "${params.results}/staramr"

    input:
    path genomes
    val scheme    
	
    output:
    path "results"
  
    shell:

    '''

    staramr search *.fasta --output-dir results \
	      --mlst-scheme !{scheme} \
		  --genome-size-lower-bound 2000000
    
    '''
}

workflow{
 	
    my_species = ["Acinetobacter_baumannii","Burkholderia_cepacia","Staphylococcus_aureus","Klebsiella_pneumoniae"]

    fastqc_files = Channel.fromFilePairs(params.pattern,flat:true)
    fastq_files = Channel.fromFilePairs(params.pattern).flatMap{it[1]}.collect()
    FASTQC (fastqc_files)
    AQUAMIS (fastq_files, params.organism)
    TORMES (AQUAMIS.out[0])
    for_amr = TORMES.out[0].flatten().map{it -> [it.simpleName,it]}
    if (params.organism in my_species){
        AMRFINDER (for_amr,params.organism)
    } else{
        println("${params.organism} not in the list. change and resume the pipeline")
    }
   
   STARAMR(AQUAMIS.out[0], params.scheme)
   //STARAMR(AQUAMIS.out[0])
}