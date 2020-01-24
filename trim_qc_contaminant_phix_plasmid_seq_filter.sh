#!/usr/bin/env bash

### Set up directory structure
BASE_DIR=/home/gvadali/ecoli

#Part1 - QC and Adaptor removal
ADAPT=$BASE_DIR/truseq_adapters.fasta

#Part2 - Contaminant removal
CONT=/home/gvadali/contaminants/phix.fasta

#Part3 - Plasmid sequences removal
PLS=/home/gvadali/ecoli/plasmid.fasta

OUT_DIR1=$BASE_DIR/qc_reads
OUT_DIR2=$BASE_DIR/phix_qc_reads
OUT_DIR3=$BASE_DIR/plasmid_removed_reads

mkdir -p $OUT_DIR1
mkdir -p $OUT_DIR1/stats_log
mkdir -p $OUT_DIR1/run_log
mkdir -p $OUT_DIR2
mkdir -p $OUT_DIR2/stats_log
mkdir -p $OUT_DIR2/run_log
mkdir -p $OUT_DIR3
mkdir -p $OUT_DIR3/stats_log
mkdir -p $OUT_DIR3/run_log

cd $BASE_DIR

## Define QC parameters
MINLEN=75
TRIMQ=10
MINAVG=20
MAXK_Adapter=25
MAXK_PhiX=31
MAXK_B6=6
MINK=11
HAM=1

## Run bbduk Part1. Adapter Removal and QC Filter
for i in `ls -1 *.fastq.gz`;do

F=`basename $i .fastq.gz`;

        bbduk.sh -Xmx1g \
                in="$F".fastq.gz \
                ref=$ADAPT \
                out=$OUT_DIR1/"$F"_qc.fastq \
                threads=4 \
                stats=$OUT_DIR1/stats_log/"$F".contaminant.stats \
                bhist=$OUT_DIR1/stats_log/"$F".base.composition.hist \
                qhist=$OUT_DIR1/stats_log/"$F".quality.hist \
                aqhist=$OUT_DIR1/stats_log/"$F".average.quality.hist \
                bqhist=$OUT_DIR1/stats_log/"$F".boxplot.quality.hist \
                lhist=$OUT_DIR1/stats_log/"$F".readLength.hist \
                gchist=$OUT_DIR1/stats_log/"$F".GCcontent.hist \
                k=$MAXK_Adapter hammingdistance=$HAM \
                ktrim=r qtrim=t mink=$MINK trimq=$TRIMQ minlength=$MINLEN minavgquality=$MINAVG \
                removeifeitherbad=f otm=t tbo=t tpe=t overwrite=t \
                &> $OUT_DIR1/run_log/"$F".log


done

##Run Fastqc on the output
cd $OUT_DIR1

fastqc *.fastq -t 4

##Generate a stats table for the output

multiqc .

mv multiqc_report.html $BASE_DIR

##PART 2 - PhiX removal

cd $OUT_DIR1

for i in `ls -1 *_qc.fastq`;do

F=`basename $i _qc.fastq`;

        bbduk.sh -Xmx1g \
                in=$OUT_DIR1/"$F"_qc.fastq \
                ref=$CONT \
                out=$OUT_DIR2/"$F"_qc_phix.fastq \
                threads=4 \
                stats=$OUT_DIR2/stats_log/"$F".contaminant.stats \
                bhist=$OUT_DIR2/stats_log/"$F".base.composition.hist \
                qhist=$OUT_DIR2/stats_log/"$F".quality.hist \
                aqhist=$OUT_DIR2/stats_log/"$F".average.quality.hist \
                bqhist=$OUT_DIR2/stats_log/"$F".boxplot.quality.hist \
                lhist=$OUT_DIR2/stats_log/"$F".readLength.hist \
                bqhist=$OUT_DIR2/stats_log/"$F".boxplot.quality.hist \
                lhist=$OUT_DIR2/stats_log/"$F".readLength.hist \
                gchist=$OUT_DIR2/stats_log/"$F".GCcontent.hist \
                k=$MAXK_PhiX hammingdistance=$HAM overwrite=t \
                &> $OUT_DIR2/run_log/"$F".log

done

##PART 3 - Plasmid sequences removal

cd $OUT_DIR2

for i in `ls -1 *_qc_phix.fastq`;do

F=`basename $i _qc_phix.fastq`;

        bbduk.sh -Xmx1g \
                in="$F"_qc_phix.fastq \
                ref=$PLS \
                out=$OUT_DIR3/"$F"_qc_phix_pls.fastq \
                threads=4 \
                stats=$OUT_DIR3/stats_log/"$F".contaminant.stats \
                bhist=$OUT_DIR3/stats_log/"$F".base.composition.hist \
                qhist=$OUT_DIR3/stats_log/"$F".quality.hist \
                aqhist=$OUT_DIR3/stats_log/"$F".average.quality.hist \
                bqhist=$OUT_DIR3/stats_log/"$F".boxplot.quality.hist \
                lhist=$OUT_DIR3/stats_log/"$F".readLength.hist \
                gchist=$OUT_DIR3/stats_log/"$F".GCcontent.hist \
                k=$MAXK_Adapter mm=f overwrite=t \
                &> $OUT_DIR3/run_log/"$F".log

done
