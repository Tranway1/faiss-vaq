#./hnsw --dataset $DATASETS/data_size1B_seed1184_len256_znorm.bin --dataset-size 25000000 --index-path /home/karimae/projects/dsseval_full_compact_journal/code/hnswlib-proj/out_25GB_M4_ef500/ --efConstruction 500 --M 4 --timeseries-size 256 --mode 0 --buffer-size 5000000 > index_25GB_M4_ef500.log

PROJECTS_ROOT=/local/chunwei/ikra/lernaean-hydra/hydra2
DATA_PATH=data/synthetic
DATASET_PATH=$PROJECTS_ROOT/$DATA_PATH
BIGDATASET_PATH=/mnt/hdd-2T-2/ikraduya
DATASETS=""
mode=0
BIG_INDEX_PATH=/mnt/hdd-2T-2/ikraduya/index_isax2_syn_100gb
ASTRO_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/ASTRO
SEISMIC_DATASET_PATH=/local/jopa/SEISMIC
SEISMICNEW_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/SEISMIC
SALD_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/SALD
DEEP1B_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/DEEP1B
SIFT_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/SIFT
GIST_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/GIST
GLOVE_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/GLOVE
SIFT1B_DATASET_PATH=/mnt/hdd-2T-4/ikraduya/SIFT1B

# Timing OPQ PCA
# INDEX="OPQ32,PQ32x8np"
# INDEX="PQ32x8np"
# ./demos/demo_ikra --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin

# INDEX="HNSW16,Flat"
# REFINE=0
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# ./notifyscript.sh "hnsw selesai"


# 1
NCODES=32
BITSSEGM=8
IMIBITS=2
# LINKS=16
# IVFCENTROIDS=256
# REFINE=0
# INDEX="PQ${NCODES}x${BITSSEGM}np"
# INDEX="PQ${NCODES}x${BITSSEGM}np,RFlat"
# INDEX="OPQ${NCODES},PQ${NCODES}x${BITSSEGM}np"
# INDEX="OPQ${NCODES},PQ${NCODES}x${BITSSEGM}np,RFlat"
# INDEX="IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np,RFlat"
INDEX="OPQ${NCODES},IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np,RFlat"
# INDEX="HNSW${LINKS},Flat"
# INDEX="IVF${IVFCENTROIDS},PQ${NCODES}x${BITSSEGM}np"
# INDEX="ITQ,LSHrt,RFlat"
# REFINE=100
## Synthetic 
# ./demos/demo_ikra --timeseries-size 256 --dataset-size 25000 --queries-size 100 --k 100 --index-string $INDEX --results "25MB_answer_${INDEX}_syn.csv" --dataset $DATASET_PATH/data_size25MB_seed1184_len256_znorm.bin --queries $DATASET_PATH/queries_size100_seed14784_len256_znorm.bin > log_${INDEX}_25MB.txt
# ./demos/demo_ikra --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "1GB_answer_${INDEX}_syn.csv" --dataset $DATASET_PATH/data_size1GB_seed1184_len256_znorm.bin --queries $DATASET_PATH/queries_size100_seed14784_len256_znorm.bin > log_${INDEX}_1GB_syn.txt
# ./demos/demo_ikra --timeseries-size 256 --dataset-size 10000000 --queries-size 100 --k 100 --index-string $INDEX --results "10GB_answer_${INDEX}_syn.csv" --dataset $BIGDATASET_PATH/data_size10GB_seed1184_len256_znorm.bin --queries $DATASET_PATH/queries_size100_seed14784_len256_znorm.bin > log_${INDEX}_10GB_syn.txt
# ./demos/demo_ikra --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "100GB_answer_${INDEX}_syn.csv" --dataset $BIGDATASET_PATH/data_size100GB_seed1184_len256_znorm.bin --queries $DATASET_PATH/queries_size100_seed14784_len256_znorm.bin > log_${INDEX}_100GB_syn.txt
## ASTRO
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 10000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/10K_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_10K_astro.txt
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt
# ./demos/demo_ikra --timeseries-size 256 --dataset-size 10000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/10GB_answer_${INDEX}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_10GB_astro.txt
# sudo clearcache.sh
REFINE="8000,16000,32000,64000,128000"
./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_100GB_astro.txt
INDEX="OPQ${NCODES},PQ${NCODES}x${BITSSEGM}np"
./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_100GB_astro.txt
./notifyscript.sh "astro opq done"
# sudo clearcache.sh
# REFINE=500
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_100GB_astro.txt
# sudo clearcache.sh
# REFINE=1000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_100GB_astro.txt
# sudo clearcache.sh
# REFINE=2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_100GB_astro.txt
# sudo clearcache.sh
# REFINE=4000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_100GB_astro.txt
## SEISMIC
# sudo clearcache.sh
# REFINE=0,500
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# INDEX="LSHrt,RFlat"
# sudo clearcache.sh
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# INDEX="PQ32x8np,RFlat"
# sudo clearcache.sh
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# INDEX="OPQ32,PQ32x8np,RFlat"
# sudo clearcache.sh
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# REFINE=2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# REFINE=4000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# REFINE=8000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
# REFINE=16000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismic.csv" --dataset $SEISMIC_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismic.txt
## SALD
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# sudo clearcache.sh
# REFINE=100,200,500,1000,2000,5000,10000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sald.txt
# sudo clearcache.sh
# REFINE=200
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sald.txt
# sudo clearcache.sh
# REFINE=400
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sald.txt
# sudo clearcache.sh
# REFINE=1000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sald.txt
## DEEP1B
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# sudo clearcache.sh
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_deep1b.txt
# sudo clearcache.sh
# IMIBITS=2
# INDEX="IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np,RFlat"
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_deep1b.txt
# IMIBITS=1
# INDEX="IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np,RFlat"
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_deep1b.txt
# REFINE=4000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_deep1b.txt
## SIFT
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift.csv" --dataset $SIFT_DATASET_PATH/sift_data.bin --queries $SIFT_DATASET_PATH/sift_queries.bin
## SIFT1B
# sudo clearcache.sh
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# sudo clearcache.sh
# IMIBITS=2
# INDEX="OPQ${NCODES},IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np"
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# sudo clearcache.sh
# IMIBITS=3
# INDEX="OPQ${NCODES},IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np"
# REFINE=100,200,500,1000,2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# INDEX="IMI2x${IMIBITS},PQ${NCODES}x${BITSSEGM}np,RFlat"
# sudo clearcache.sh
# REFINE=500
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# REFINE=1000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# REFINE=2000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# REFINE=4000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
# REFINE=8000
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_sift1b.txt
## GIST
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 960 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_gist.csv" --dataset $GIST_DATASET_PATH/gist_data.bin --queries $GIST_DATASET_PATH/gist_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_gist.txt
## Glove
# INDEX="Pad208,OPQ${NCODES},PQ${NCODES}x${BITSSEGM}np"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 200 --dataset-size 1193514 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_glove.csv" --dataset $GLOVE_DATASET_PATH/glove_data.bin --queries $GLOVE_DATASET_PATH/glove_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_glove.txt

# REFINE=0
# INDEX="LSHrt"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="ITQ,LSHrt"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# ./notifyscript.sh "run lsh selesai"

# REFINE=0
# # 256, 8 bits
# INDEX="PQ32x8np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="OPQ32,PQ32x8np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# # 256, 4 bits
# INDEX="PQ64x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# INDEX="Pad128,PQ64x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="OPQ64,PQ64x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# INDEX="Pad128,OPQ64,PQ64x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# # 128, 8 bits
# INDEX="PQ16x8np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="OPQ16,PQ16x8np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# # 128, 4 bits
# INDEX="PQ32x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="OPQ32,PQ32x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# # 64, 8 bits
# INDEX="PQ8x8np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="OPQ8,PQ8x8np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# wait
# # 64, 4 bits
# INDEX="PQ16x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="OPQ16,PQ16x4np"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# echo "waiting"
# wait
# ./notifyscript.sh "run faiss selesai"

## GIST
# INDEX="ITQ64,LSHrt"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 960 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_gist.csv" --dataset $GIST_DATASET_PATH/gist_data.bin --queries $GIST_DATASET_PATH/gist_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_gist.txt
# INDEX="ITQ128,LSHrt"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 960 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_gist.csv" --dataset $GIST_DATASET_PATH/gist_data.bin --queries $GIST_DATASET_PATH/gist_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_gist.txt
# INDEX="ITQ256,LSHrt"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 960 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_gist.csv" --dataset $GIST_DATASET_PATH/gist_data.bin --queries $GIST_DATASET_PATH/gist_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_gist.txt
## Glove
# INDEX="ITQ64,LSHrt"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 200 --dataset-size 1193514 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_glove.csv" --dataset $GLOVE_DATASET_PATH/glove_data.bin --queries $GLOVE_DATASET_PATH/glove_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_glove.txt
# INDEX="ITQ128,LSHrt"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 200 --dataset-size 1193514 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_glove.csv" --dataset $GLOVE_DATASET_PATH/glove_data.bin --queries $GLOVE_DATASET_PATH/glove_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_glove.txt
# INDEX="Pad256,ITQ256,LSHrt"  # maybe need pad?
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 200 --dataset-size 1193514 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_glove.csv" --dataset $GLOVE_DATASET_PATH/glove_data.bin --queries $GLOVE_DATASET_PATH/glove_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_glove.txt