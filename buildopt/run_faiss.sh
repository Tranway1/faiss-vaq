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

INDEX="HNSW32,Flat"
REFINE=0
(./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
(./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
(./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
(./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
(./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
wait
./notifyscript.sh "hnsw selesai"

# SEISMIC
# REFINE=0,100,200,300,400,500,1000,2000,4000,8000,16000,32000
# INDEX="PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt

# REFINE=0,100,200,300,400,500,1000,2000,4000,8000,16000,32000
# INDEX="IMI2x1,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt

# REFINE=0,100,200,300,400,500,1000,2000,4000,8000,16000,32000
# INDEX="IMI2x2,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt

# REFINE=0,100,200,300,400,500,1000,2000,4000,8000,16000,32000
# INDEX="OPQ32,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt

# REFINE=0,100,200,300,400,500,1000,2000,4000,8000,16000,32000
# INDEX="OPQ32,IMI2x1,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt

# REFINE=0,100,200,300,400,500,1000,2000,4000,8000,16000,32000
# INDEX="OPQ32,IMI2x2,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 99999954 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_seismicnew.txt

# DEEP
# REFINE=0,100,500,1000,2000,4000
# INDEX="IMI2x1,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_deep1b.txt

# REFINE=0,100,500,1000,2000,4000
# INDEX="OPQ32,IMI2x1,PQ32x8np,RFlat"
# ./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 100000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/100M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_100M_deep1b.txt

./notifyscript.sh "faiss imi imi selesai"

# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="PQ32x4fs"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &
# INDEX="PQ16x4fs"
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1GB_answer_${INDEX}_refine${REFINE}_astro.csv" --dataset $ASTRO_DATASET_PATH/astro_data.bin --queries $ASTRO_DATASET_PATH/astro_queries.bin > log/log_${INDEX}_refine${REFINE}_1GB_astro.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 256 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_seismicnew.csv" --dataset $SEISMICNEW_DATASET_PATH/seismic_data.bin --queries $SEISMIC_DATASET_PATH/seismic_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_seismicnew.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sald.csv" --dataset $SALD_DATASET_PATH/sald_data.bin --queries $SALD_DATASET_PATH/sald_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sald.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_sift1b.csv" --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_sift1b.txt) &
# (./demos/demo_ikra --refine ${REFINE} --timeseries-size 96 --dataset-size 1000000 --queries-size 100 --k 100 --index-string $INDEX --results "answer/1M_answer_${INDEX}_refine${REFINE}_deep1b.csv" --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin > log/log_${INDEX}_refine${REFINE}_1M_deep1b.txt) &

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
echo "waiting"
wait
./notifyscript.sh "run faiss selesai"
