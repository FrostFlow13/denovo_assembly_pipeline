#!/usr/bin/env nextflow

/*
 * Default testing parameters
 */
params.batch = 'test_results'
params.srdir = "/srv/dev/denovo_assembly_pipeline/data/short_read"
params.samples = "/srv/dev/denovo_assembly_pipeline/test-samples.csv"

// Include modules
include { shortTrim as shortTrim1} from "./modules/shortTrim.nf"

workflow {

    // Create a channel for sample information
    samples_ch = Channel.fromPath(params.samples)
                        .splitCsv( skip: 1 )

    // Run fastp trimming and QC
    outdir = '0-short_trim'
    shortTrim1(params.srdir, samples_ch, outdir)
}
