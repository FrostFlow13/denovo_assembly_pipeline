# DeNoAsPi (_De Novo_ Assembly Pipeline)

Hello! I am Dr. Andrew Woodruff, and this repository is an attempt to turn the code/processes I used for generation of _de novo_ assemblies using deep long- and short-read sequencing for a heterozygous, diploid organism (https://github.com/FrostFlow13/1376-denovo-assembly) into a proper scalable, semi-automated pipeline (with some intentionally manual steps). This pipeline is designed specifically for _Candida albicans_, but should be able to be modified to work for other organisms as well. If I ever get the time, I may make a branch that is more organism agnostic (especially after I get more Nextflow experience under my belt).

## Setup Guide

The workflow was developed and tested on the following:

 * Ubuntu: `24.04.1 LTS (GNU/Linux 4.4.0-19041-Microsoft x86_64)`
 * Bash: `GNU bash, version 5.2.21(1)-release (x86_64-pc-linux-gnu)`
 * Conda: `25.1.1`
 * [Nextflow](https://www.nextflow.io/): `24.10.5`
 * Java: `openjdk version "17.0.10" 2024-01-16`

### Setup - Conda and Mamba

Perform the following steps to set up Conda 25.1.1. This is important, as Conda 25.3.X appears to be incompatible with Nextflow 24.10.5 (Nextflow cannot make Conda environments, due to it using a depreciated argument).

   ```bash
   # Pulls down Miniconda3 version 25.1.1 with Python version 3.12.9
   wget https://repo.anaconda.com/miniconda/Miniconda3-py312_25.1.1-2-Linux-x86_64.sh
   
   # Runs the installation script
   bash Miniconda3-py312_25.1.1-2-Linux-x86_64.sh
   
   # When prompted to review a license agreement, use the up and down arrow keys to navigate to the bottom, then enter "yes" to agree when prompted to accept the license
   
   # Verify installation directory (default is the user's home directory - this is where we want it!) - press the Enter key to confirm
   
   # When asked whether to update the shell profile to initialize Conda by default, enter "yes" - this will launch Conda whenever you start up a session
   
   # Close your shell/session and open a new one, and you should see (base) in the command line
   
   # Test Conda for functionality
   conda list
   
   # If it passes, remove the installer
   rm Miniconda3-py312_25.1.1-2-Linux-x86_64.sh
   
   # Setup Conda's channels (the "auto_update_conda False" config option ensures Conda doesn't try to update itself past 25.1.1, due to the problem with Nextflow described above)
   conda config --add channels defaults
   conda config --add channels bioconda
   conda config --add channels conda-forge
   conda config --set channel_priority flexible
   conda config --set auto_update_conda False

   # Install Mamba in base environment
   conda install -n base mamba=2.1.0
```

### Setup - Nextflow and Java

For both Nextflow and Java, installation was performed exactly as written in the [Nextflow installation instructions](https://nextflow.io/docs/stable/install.html), including adding the directory to ~/.bashrc.

   ```bash
   # Install SDKMan in the current directory (ideally the $HOME directory)
   curl -s https://get.sdkman.io | bash
   
   # Close the terminal and open a new terminal
   
   # Install Java
   sdk install java 17.0.10-tem
   
   # Confirm Java is installed correctly
   java -version
   
   # Install Nextflow in the current directory (ideally the $HOME directory)
   curl -s https://get.nextflow.io | bash
   
   # Make Nextflow executable
   chmod +x nextflow
   
   # Move Nextflow into an executable path
   mkdir -p $HOME/.local/bin/
   mv nextflow $HOME/.local/bin/
   
   # Adds the $HOME/.local/bin/ to PATH permanently
   echo '# Adds the $HOME/.local/bin/ to PATH for Nextflow' >> $HOME/.bashrc
   echo 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.bashrc
   ```

If you are using a version of Nextflow differing from 24.10.5, you can temporarily switch to another version of Nextflow using the following (assuming you run into any compatability issues):
`NXF_VER=24.10.5 nextflow [run/info/etc]`

The nice part about NXF_VER is that once you run it once, it won't have to download the dependencies again, making it fairly easy to run older versions if necessary.

## Usage

[IN DEVELOPMENT]

## Closing Information

For more information, please feel free to contact myself or Dr. Matthew Anderson (https://genetics.wisc.edu/staff/anderson-matt/), my Ph.D. advisor during my time at The Ohio State University. For some of the results that came from near-complete products of the original assembly protocol work (https://github.com/FrostFlow13/1376-denovo-assembly), please see Chapter 3 of my dissertation (http://rave.ohiolink.edu/etdc/view?acc_num=osu1712852304413336). The read dataset will be publicly available on May 5 2025 at "BioProject: PRJNA1117514". I am also more than happy to provide my in-progress _Candida albicans_ SC5314 assembly upon request (the step I last ended on was manually validating long (~8+ bp) homopolymers).

I cannot guarantee it will work for every organism or dataset, especially for organisms/strains that have low heterozygosity of their genomes or long (~75-100+ kb) tracts of homozygosity between heterozygous regions, but it worked for a CRISPR-competent strain of _Candida albicans_ SC5314 (a diploid single-celled yeast, and specifically a Chr5AB disomic derivative of AHY940 from https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5422035/, designated MAY1376).

Please do not hesitate to ask questions, as I am going on a journey here to learn Nextflow for this process. I am not a CLASSICALLY trained bioinformatician or programmer beyond a few classes - I was just a graduate student/researcher at the time I made my first repository (which, in retrospect, was more just an online host for my work instruction file), but I did make a _de novo_, telomere-to-telomere, haplotype phased assembly. As stated above, this repository is me furthering my skills by turning it into a scalable pipeline.

## Background on Data Used for Development

For full disclosure, the following was what I did prior to running this pipeline:

>For short-read sequencing, DNA was extracted from overnight cultures grown at 30°C (~10^8 cells) using the Zymogen Quick-DNA Fungal/Bacterial Miniprep Kit (Zymogen, CAT# D6005). gDNA concentration was quantified using the Qubit dsDNA Broad Range Assay Kit (Invitrogen, CAT# Q32853). Following quantification, the samples were sent to the Applied Microbiology Services Lab (AMSL) at The Ohio State University for processing. Libraries were constructed via tagmentation and dual index barcoding using a modified protocol for the Illumina (L) Tagmentation Kit (Illumina, CAT# 20040537) to produce average final fragment sizes of approximately 450-500 bp. The libraries were sequenced for 2x150 paired-end reads on an Illumina NextSeq 2000. Reads were demultiplexed and Illumina adaptors were trimmed by AMSL. Read quality was assessed using FastQC (v0.11.7), and low-quality positions were trimmed using Trimmomatic (v0.35 LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:35), after which the trimmed data were checked again using FastQC. Reads were mapped to the C. albicans reference genome Assembly 21 (A21-s02-m09-r10) – obtained March 2, 2021 from the Candida Genome Database website (http://www.candidagenome.org/download/sequence/C_albicans_SC5314/Assembly21/archive/C_albicans_SC5314_version_A21-s02-m09-r10_chromosomes.fasta.gz) – using Bowtie 2 (v2.2.6-2) with parameters “-3 1” to improve downstream analysis. SAMtools (v0.1.19) was then used to generate .bam files, for read sorting, and sample indexing. Read alignment quality was interrogated via visual scanning using Integrative Genomics Viewer (IGV, v2.9.2) for aneuploidy, loss of heterozygosity (LOH), and major genomic rearrangements. Secondary checks for ploidy and heterozygosity were performed using YMAP (http://lovelace.cs.umn.edu/Ymap/) for visualization. The final coverage was found to be ~80X.
>
>For long-read sequencing, an intact cell pellet of MAY1376 was sent to the University of Wisconsin-Madison’s Biotechnology Center (UWBC). UWBC performed high molecular weight DNA extraction on the sample to prepare Oxford Nanopore barcoded libraries, with DNA fragment lengths being on average ~20 kb. Libraries were then sequenced on a PromethION 24 using a FLO-PRO114M (R10.4.1) flow cell and an SQK-NBD114-24 (V14) kit for 12 hours. Prior to data delivery, basecalling was performed by UWBC using Guppy 6.4.6 (high-accuracy model, 400 bps) and reads were demultiplexed. The final coverage was found to be ~400X (we had initially asked for ~8X coverage), with ~300X coverage after removing all reads below 10 kilobases (kb) and ~200X coverage after removing all reads below 25 kb.

