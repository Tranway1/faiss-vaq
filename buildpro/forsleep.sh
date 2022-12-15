ASTRO_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/ASTRO
SEISMIC_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/SEISMIC
SALD_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/SALD
DEEP1B_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/DEEP1B
SIFT1B_DATASET_PATH=/mnt/hdd-2T-4/ikraduya/SIFT1B

# SIFT1M
## PQ
# BUDGET=16x8
# for CLUSTER in 2048 4096; do
#   ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000\
#     --queries-size 100 --k 100 --index-string PQ${BUDGET}np\
#     --results answer_pro/SIFT1M_PQ${BUDGET}_cluster${CLUSTER}\
#     --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin\
#     --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin\
#     --pro-cluster ${CLUSTER} --visit 0.5,0.25,0.1,0.05
# done
# ## OPQ
# for CLUSTER in 2048 4096; do
#   ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000\
#     --queries-size 100 --k 100 --index-string PQ${BUDGET}np\
#     --results answer_pro/SIFT1M_OPQ${BUDGET}_cluster${CLUSTER}\
#     --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin\
#     --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin\
#     --pro-cluster ${CLUSTER} --visit 0.5,0.25,0.1,0.05 --is-opq 1
# done


# SALD1M
## PQ
BUDGET=16x8
for CLUSTER in 128 512 1024; do
  ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000\
    --queries-size 100 --k 100 --index-string PQ${BUDGET}np\
    --results answer_pro/SALD1M_PQ${BUDGET}_cluster${CLUSTER}\
    --dataset $SALD_DATASET_PATH/sald_data.bin\
    --queries $SALD_DATASET_PATH/sald_queries.bin\
    --pro-cluster ${CLUSTER} --opq-segment 16 --visit 0.5,0.25,0.1,0.05
  for V in 50 25 10 05; do 
    python3 compute_accuracy.py answer_pro/SALD1M_PQ${BUDGET}_cluster${CLUSTER}_V0.${V}0000.csv groundtruth_1M_sald.csv
  done
done
## OPQ
# for CLUSTER in 128 512 1024; do
#   ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000\
#     --queries-size 100 --k 100 --index-string PQ${BUDGET}np\
#     --results answer_pro/SALD1M_OPQ${BUDGET}_cluster${CLUSTER}\
#     --dataset $SALD_DATASET_PATH/sald_data.bin\
#     --queries $SALD_DATASET_PATH/sald_queries.bin\
#     --pro-cluster ${CLUSTER} --visit 0.5,0.25,0.1,0.05 --is-opq 1
# for V in 50 25 10 05; do 
#   python3 compute_accuracy.py answer_pro/SALD1M_OPQ${BUDGET}_cluster128_V0.${V}0000.csv groundtruth_1M_sald.csv
# done
# done


# # ASTRO
# ## PQ
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_PQ32x8_cluster128\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 128 --visit 0.5,0.25,0.1,0.05
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_PQ32x8_cluster512\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 512 --visit 0.5,0.25,0.1,0.05
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_PQ32x8_cluster1024\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 1024 --visit 0.5,0.25,0.1,0.05
# ## OPQ
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_OPQ32x8_cluster128\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 128 --visit 0.5,0.25,0.1,0.05 --is-opq 1
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_OPQ32x8_cluster512\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 512 --visit 0.5,0.25,0.1,0.05 --is-opq 1
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_OPQ32x8_cluster1024\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 1024 --visit 0.5,0.25,0.1,0.05 --is-opq 1

# # ASTRO
# ## PQ
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_PQ32x8_cluster128\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 128 --visit 0.5,0.25,0.1,0.05
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_PQ32x8_cluster512\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 512 --visit 0.5,0.25,0.1,0.05
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_PQ32x8_cluster1024\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 1024 --visit 0.5,0.25,0.1,0.05
# ## OPQ
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_OPQ32x8_cluster128\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 128 --visit 0.5,0.25,0.1,0.05 --is-opq 1
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_OPQ32x8_cluster512\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 512 --visit 0.5,0.25,0.1,0.05 --is-opq 1
# ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#   --queries-size 100 --k 100 --index-string PQ32x8np\
#   --results answer_pro/ASTRO1M_OPQ32x8_cluster1024\
#   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#   --pro-cluster 1024 --visit 0.5,0.25,0.1,0.05 --is-opq 1

# ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string PQ8x4np --results answer_pro/SIFT1M_PQ8x4_cluster32 --dataset /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_data.bin --queries /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_queries.bin --pro-cluster 32 --visit 1,0.5
# ./demos/demo_pro --timeseries-size 128 --dataset-size 10000 --queries-size 100 --k 100 --index-string PQ8x8np --results answer_pro/siftsmall_PQ8x8_cluster4 --dataset /local/chunwei/ikra/faiss/buildpro/siftsmall/siftsmall_data.bin --queries /local/chunwei/ikra/faiss/buildpro/siftsmall/siftsmall_query.bin --pro-cluster 4 --visit 1,0.5
