#!/usr/bin/env nextflow

/*
 * Use fastp (v0.24.0) to perform short-read trimming and produce QC reports for before and after trimming
 */
process shortTrim {

    conda 'bioconda::fastp==0.24.0'

    publishDir "${PWD}/${params.batch}/${samples[0]}/${outdir}", mode: 'copy'

    input:
        val srdir
        val samples
        val outdir
    
    output:
        path "${samples[0]}-fastp.html"
        path "${samples[0]}-fastp.json"
        path "${samples[0]}_R1_trim.fastq.gz"
        path "${samples[0]}_R2_trim.fastq.gz"
    
    // This script performs 5' trimming and then a front-to-tail scan for trimming with a 4 bp window (both with a quality score cutoff of 20), removes all reads smaller than 35 bp, and removes the last base from both the forward and reverse reads
    script:
    """
    fastp -j ${samples[0]}-fastp.json -h ${samples[0]}-fastp.html -5 -r -l 35 -t 1 -T 1 -i ${srdir}/${samples[1]} -I ${srdir}/${samples[2]} -o ${samples[0]}_R1_trim.fastq.gz -O ${samples[0]}_R2_trim.fastq.gz
    """
}
