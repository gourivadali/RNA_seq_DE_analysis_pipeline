#!/usr/bin/env bash

### Set up directory structure
BASE_DIR=/nfs/vedanta/home/gvadali/ecoli/aligned
GTF_file=/nfs/vedanta/home/gvadali/ecoli/ecoli_dh10b_annotation.gtf
OP_DIR=/nfs/vedanta/home/gvadali/ecoli/htseq_counts

mkdir -p $OP_DIR

cd $BASE_DIR

for i in `ls -1 *.bam`;do

F=`basename $i Aligned.sortedByCoord.out.bam`;

htseq-count -t exon -i gene_id -f bam "$F"Aligned.sortedByCoord.out.bam $GTF_file > $OP_DIR/"$F"_counts.out &> $OP_DIR/Log.output

done
