#!/usr/bin/env nextflow

/*
 * Default testing parameters
 */
params.batch = 'test_results'
params.srdir = "/srv/dev/denovo_assembly_pipeline/data/short_read"
params.samples = "/srv/dev/denovo_assembly_pipeline/test-samples.csv"

// Include modules
include { shortTrim as shortTrim1 } from "./modules/shortTrim.nf"
include { multiQC as multiQC1 } from "./modules/multiQC.nf"

workflow {

    // Create a channel for sample information
    samples_ch = Channel.fromPath(params.samples)
                        .splitCsv( skip: 1 )

    // Run fastp trimming and QC, then place outputs into individual directories
    outdir = '0-short_trim'
    shortTrim1(params.srdir, samples_ch, outdir)

    // Run MultiQC report generation, then places report into a general directory
    outdir = '0-multiQC_report'
    multiQC1(shortTrim1.out.fpjson.collect(), outdir)
}
