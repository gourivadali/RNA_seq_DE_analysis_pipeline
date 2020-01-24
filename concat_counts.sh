#!/usr/bin/env bash

### Set up directory structure
BASE_DIR=$1

cd $BASE_DIR

for i in `ls -1 *_counts.out`;do

F=`basename $i _counts.out`;

cat "$F"_counts.out | sed -e "s/$/\t$F/" >> merged_counts.txt

done
