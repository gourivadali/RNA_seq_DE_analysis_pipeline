#!/usr/bin/env bash

BASE_DIR=$1
READS_DIR=$BASE_DIR/plasmid_removed_reads
OP_DIR=$BASE_DIR/aligned

#mkdir -p $BASE_DIR/starjob1
mkdir -p $OP_DIR

cd $READS_DIR

for i in `ls -1 *.fastq`;do

F=`basename $i _qc_phix_pls.fastq`;

STAR --genomeDir $BASE_DIR/star-genome \
--readFilesIn $READS_DIR/"$F"_qc_phix_pls.fastq \
--runThreadN 6 \
--sjdbGTFfile $BASE_DIR/ecoli_dh10b_annotation.gff3 --sjdbGTFtagExonParentTranscript Parent \
--outSAMtype BAM SortedByCoordinate \
--outFileNamePrefix $OP_DIR/"$F";

done
