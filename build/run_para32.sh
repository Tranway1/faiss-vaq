#!/bin/sh

INDEX=$1
DSIZE="1M"
EFC=$3
EFS=$4
echo "file,encding,query,precision,recall,map" >> runtime.txt

for INDEX in 32 64; do
  for EFC in 200 100 50 10; do
    for EFS in 8 16 32 64; do
       ./run_hnswefcefs.sh "HNSW${INDEX},PQ32x8np" ${DSIZE} ${EFC} ${EFS}
    done
  done
done


