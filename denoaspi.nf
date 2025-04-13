#!/usr/bin/env nextflow

/*
 * Use fastp (v0.24.0) to perform short read trimming and produce QC reports for before and after trimming
 */
process shortTrim {

    conda 'bioconda::fastp==0.24.0'

    publishDir 'results/short_trim', mode: 'copy'

    input:
        val sample
    
    output:
        path "${sample[0]}-fastp.html"
        path "${sample[0]}-fastp.json"
    
    // This script performs 5' trimming and then a front-to-tail scan for trimming with a 4 bp window (both with a quality score cutoff of 20), removes all reads smaller than 35 bp, and removes the last base from both the forward and reverse reads
    script:
    """
    fastp -j ${sample[0]}-fastp.json -h ${sample[0]}-fastp.html -5 -r -l 35 -t 1 -T 1 -i ./data/short_read/${sample[1]}.fastq.gz -I ./data/short_read/${sample[2]}.fastq.gz
    """
}

/*
 * Default testing parameters
 */
params.sample = 'samples.csv'

workflow {

    // Run fastp trimming and QC
    shortTrim(params.sample)
}




// Temporarily commented out actual trim output
//  -o 1376_R1out.fastq.gz -O 1376_R2out.fastq.gz
