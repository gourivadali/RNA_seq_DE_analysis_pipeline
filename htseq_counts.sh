#!/usr/bin/env bash

### Set up directory structure
BASE_DIR=$1
GTF_file=$BASE_DIR/ecoli_dh10b_annotation.gtf
OP_DIR=$BASE_DIR/htseq_counts

mkdir -p $OP_DIR

cd $BASE_DIR

for i in `ls -1 *.bam`;do

F=`basename $i Aligned.sortedByCoord.out.bam`;

htseq-count -t exon -i gene_id -f bam "$F"Aligned.sortedByCoord.out.bam $GTF_file > $OP_DIR/"$F"_counts.out &> $OP_DIR/Log.output

done
