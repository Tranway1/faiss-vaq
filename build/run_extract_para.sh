#!/bin/sh

INDEX=$1
DSIZE="1M"
EFC=$3
EFS=$4
echo "file,encding,query,precision,recall,map" >> extract-runtime.txt

for INDEX in 8 16 32 64; do
  for EFC in 200 100 50 10; do
    for EFS in 8 10 16 32 64; do
       ./run_extract_hnswefcefs.sh "HNSW${INDEX},PQ32x8np" ${DSIZE} ${EFC} ${EFS}
    done
  done
done


