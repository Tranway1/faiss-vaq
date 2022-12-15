#hnsw pq
#INDEX="HNSW32,PQ32x8np"
#INDEX="OPQ32,HNSW32,PQ32x8np"
#INDEX="HNSW32,Flat"
INDEX=$1
DSIZE=$2
EFC=$3
EFS=$4

echo "running ${DSIZE}_${INDEX}_efc${EFC}efs${EFS}"

./run_faiss_log.sh ${INDEX} SIFT ${DSIZE} "log" ${EFC} ${EFS} > log_base/SIFT${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
./run_faiss_log.sh ${INDEX} SEISMIC ${DSIZE} "log"  ${EFC} ${EFS} > log_base/SEISMIC${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
./run_faiss_log.sh ${INDEX} SALD ${DSIZE} "log"  ${EFC} ${EFS} > log_base/SALD${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
./run_faiss_log.sh ${INDEX} DEEP ${DSIZE} "log"  ${EFC} ${EFS} > log_base/DEEP${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
./run_faiss_log.sh ${INDEX} ASTRO ${DSIZE} "log"  ${EFC} ${EFS} > log_base/ASTRO${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt


python3 compute_accuracy.py answer/SIFT_${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.csv groundtruth_${DSIZE}_sift1b.csv >> log_base/SIFT${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
python3 compute_accuracy.py answer/SEISMIC_${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.csv groundtruth_${DSIZE}_seismic.csv >> log_base/SEISMIC${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
python3 compute_accuracy.py answer/SALD_${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.csv groundtruth_${DSIZE}_sald.csv >> log_base/SALD${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
python3 compute_accuracy.py answer/DEEP_${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.csv groundtruth_${DSIZE}_deep1b.csv >> log_base/DEEP${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt
python3 compute_accuracy.py answer/ASTRO_${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.csv groundtruth_${DSIZE}_astro.csv >> log_base/ASTRO${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt

python3 extract.py log_base/SIFT${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt >> runtime.txt
python3 extract.py log_base/SEISMIC${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt  >> runtime.txt
python3 extract.py log_base/SALD${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt >> runtime.txt
python3 extract.py log_base/DEEP${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt >> runtime.txt
python3 extract.py log_base/ASTRO${DSIZE}_${INDEX}_efc${EFC}efs${EFS}.txt >> runtime.txt
