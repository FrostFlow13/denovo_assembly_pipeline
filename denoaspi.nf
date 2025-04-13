#!/usr/bin/env nextflow

/*
 * Use fastp (v0.24.0) to perform short read trimming and produce QC reports for before and after trimming
 */
process shortTrim {

    conda 'bioconda::fastp==0.24.0'

    publishDir 'results/short_trim', mode: 'copy'

    input:
        val srdir
        val samples
    
    output:
        path "${samples[0]}-fastp.html"
        path "${samples[0]}-fastp.json"
    
    // This script performs 5' trimming and then a front-to-tail scan for trimming with a 4 bp window (both with a quality score cutoff of 20), removes all reads smaller than 35 bp, and removes the last base from both the forward and reverse reads
    script:
    """
    fastp -j ${samples[0]}-fastp.json -h ${samples[0]}-fastp.html -5 -r -l 35 -t 1 -T 1 -i ${srdir}/${samples[1]} -I ${srdir}/${samples[2]}
    """
}

/*
 * Default testing parameters
 */
params.srdir = '/srv/dev/denovo_assembly_pipeline/data/short_read'
params.samples = 'samples.csv'

workflow {

    // Create a channel for sample information
    samples_ch = Channel.fromPath(params.samples)
                        .splitCsv()

    // Run fastp trimming and QC
    shortTrim(params.srdir, samples_ch)
}




// Temporarily commented out actual trim output
//  -o 1376_R1out.fastq.gz -O 1376_R2out.fastq.gz
