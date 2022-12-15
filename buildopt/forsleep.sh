# ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string PQ32x8np --results answer_pro/SIFT1M_OPQ32x8_cluster32 --dataset /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_data.bin --queries /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_queries.bin --pro-cluster 32 --visit 1,0.5,0.25,0.125
# ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string PQ32x8np --results answer_pro/SIFT1M_OPQ32x8_cluster64 --dataset /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_data.bin --queries /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_queries.bin --pro-cluster 64 --visit 1,0.5,0.25,0.125

./demos/demo_pro --timeseries-size 128 --dataset-size 1000000 --queries-size 100 --k 100 --index-string PQ8x4np --results answer_pro/SIFT1M_PQ8x4_cluster32 --dataset /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_data.bin --queries /mnt/hdd-2T-4/ikraduya/SIFT1B/sift1b_queries.bin --pro-cluster 32 --visit 1,0.5
