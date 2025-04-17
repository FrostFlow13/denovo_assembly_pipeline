#!/usr/bin/env nextflow

/*
 * Default testing parameters
 */
params.batch = 'test_results'
params.srdir = "${PWD}/data/short_read"
params.samples = "${PWD}/test-samples.csv"

// Include modules
include { shortTrim } from "${PWD}/modules/shortTrim.nf"

workflow {

    // Create a channel for sample information
    samples_ch = Channel.fromPath(params.samples)
                        .splitCsv( skip: 1 )

    // Run fastp trimming and QC
    shortTrim(params.srdir, samples_ch)
}
