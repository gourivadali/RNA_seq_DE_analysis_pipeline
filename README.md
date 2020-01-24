# RNA_seq_DE_analysis_pipeline
This pipeline is used to run the RNA-Seq workflow for performing Differential Expression Analysis

**Note** Prior to running the workflow. There are a series of QC steps performed to eventually obtain the readcount matrix of genes and the number of reads they mapped to in every sample.

### RNA Seq QC pipeline used
1. The split replicate fastq files were first merged so that we obtain 2 replicates per state.
2. The merged fastq files underwent quality trimming, FastQC stats generation using the `trim_qc_contaminant_phix_plasmid_seq_filter.sh`. I generated a multiqc report of all the FastQC stats on every .fastq file in 1 report.
3. TruSeq adapter reads, phix reads (a regular illumina spike-in) and plasmid sequences were removed from the qc-ed fastq by using the bbduk.sh script from the bbMap tools package within the `trim_qc_contaminant_phix_plasmid_seq_filter.sh` file.
4. Once checked for all of the above, the fastq files were then aligned to the ecoli refeence genome downloaded from NCBI-RefSeq using a splice aware aligner, STAR.The script used was `run_starjob.sh`
5. Once aligned to the reference genome, `htseq-counts` was used to count the genes mapped to the genome and generate a merged count matrix file to feed through the DESeq2 RNA-Seq analysis pipeline.
6. In the respoitory you will find all the scripts needed to run the QC pipeline and the files needed to run the RNA Seq DE analysis workflow to obtain the differential genes between the two states.
