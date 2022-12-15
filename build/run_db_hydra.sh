ASTRO_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/ASTRO
SEISMIC_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/SEISMIC
SALD_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/SALD
DEEP1B_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/DEEP1B
SIFT1B_DATASET_PATH=/mnt/hdd-2T-4/ikraduya/SIFT1B

# SIFT1M
## PQ
if [ "$1" = "SIFT" ]; then
  run_sift()
  {
    TYPE=$1
    BUDGET=$2
    CONFIG=$3
    CLUSTER=$4
    SEGMENT=$5
    if [ "$TYPE" = "OPQ" ]; then 
      ISOPQ=1
    else 
      ISOPQ=0
    fi
    VISIT="0.5,0.25,0.1,0.05,0.025,0.01"
    # ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000\
    #   --queries-size 100 --k 100 --index-string PQ${CONFIG}np\
    #   --results answer_pro/SIFT1M_${TYPE}${CONFIG}_cluster${CLUSTER}\
    #   --dataset $SIFT1B_DATASET_PATH/sift1b_data.bin\
    #   --queries $SIFT1B_DATASET_PATH/sift1b_queries.bin\
    #   --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    #   --visit ${VISIT} --is-opq $ISOPQ --budget ${BUDGET}
    for C in 128 512 1024 2048; do
      for V in 500 250 100 050 025 010; do
        python3 compute_accuracy.py answer_pro/SIFT1M_${TYPE}${CONFIG}_cluster${CLUSTER}_cluster${C}_V0.${V}000.csv groundtruth_1M_sift1b.csv
      done
    done
  }

  CLUSTER="128,512,1024,2048"
  # CLUSTER="8"
  run_sift PQ 256 32x8 $CLUSTER 32
  # run_sift PQ 128 16x8 $CLUSTER 16
  run_sift OPQ 256 32x8 $CLUSTER 32
  # run_sift OPQ 128 16x8 $CLUSTER 16
elif [ "$1" = "SALD" ]; then
  run_sald()
  {
    TYPE=$1
    BUDGET=$2
    CONFIG=$3
    CLUSTER=$4
    SEGMENT=$5
    VISIT="0.5,0.25,0.1,0.05,0.025,0.01"
    if [ "$TYPE" = "OPQ" ]; then 
      ISOPQ=1
    else 
      ISOPQ=0
    fi
    # ./demos/demo_pro --timeseries-size 128 --dataset-size 1000000\
    #   --queries-size 100 --k 100 --index-string PQ${CONFIG}np\
    #   --results answer_pro/SALD1M_${TYPE}${CONFIG}_cluster${CLUSTER}\
    #   --dataset $SALD_DATASET_PATH/sald_data.bin\
    #   --queries $SALD_DATASET_PATH/sald_queries.bin\
    #   --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    #   --visit ${VISIT} --is-opq $ISOPQ --budget ${BUDGET}
    for C in 128 512 1024 2048; do
      for V in 500 250 100 050 025 010; do
        python3 compute_accuracy.py answer_pro/SALD1M_${TYPE}${CONFIG}_cluster${CLUSTER}_cluster${C}_V0.${V}000.csv groundtruth_1M_sald.csv
      done
    done
  }

  CLUSTER="128,512,1024,2048"
  run_sald PQ 256 32x8 $CLUSTER 32
  # run_sald PQ 128 16x8 $CLUSTER 16
  run_sald OPQ 256 32x8 $CLUSTER 32
  # run_sald OPQ 128 16x8 $CLUSTER 16
elif [ "$1" = "ASTRO" ]; then
  run_astro()
  {
    TYPE=$1
    BUDGET=$2
    CONFIG=$3
    CLUSTER=$4
    SEGMENT=$5
    VISIT="0.5,0.25,0.1,0.05,0.025,0.01"
    if [ "$TYPE" = "OPQ" ]; then 
      ISOPQ=1
    else 
      ISOPQ=0
    fi
    # ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
    #   --queries-size 100 --k 100 --index-string PQ${CONFIG}np\
    #   --results answer_pro/ASTRO1M_${TYPE}${CONFIG}_cluster${CLUSTER}\
    #   --dataset $ASTRO_DATASET_PATH/astro_data.bin\
    #   --queries $ASTRO_DATASET_PATH/astro_queries.bin\
    #   --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    #   --visit ${VISIT} --is-opq $ISOPQ --budget ${BUDGET}
    for C in 128 512 1024 2048; do
      for V in 500 250 100 050 025 010; do
        python3 compute_accuracy.py answer_pro/ASTRO1M_${TYPE}${CONFIG}_cluster${CLUSTER}_cluster${C}_V0.${V}000.csv groundtruth_1M_astro.csv
      done
    done
  }

  CLUSTER="128,512,1024,2048"
  run_astro PQ 256 32x8 $CLUSTER 32
  # run_astro PQ 128 16x8 $CLUSTER 16
  run_astro OPQ 256 32x8 $CLUSTER 32
  # run_astro OPQ 128 16x8 $CLUSTER 16
elif [ "$1" = "SEISMIC" ]; then
  run_seismic()
  {
    TYPE=$1
    BUDGET=$2
    CONFIG=$3
    CLUSTER=$4
    SEGMENT=$5
    VISIT="0.5,0.25,0.1,0.05,0.025,0.01"
    if [ "$TYPE" = "OPQ" ]; then 
      ISOPQ=1
    else 
      ISOPQ=0
    fi
    # ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
    #   --queries-size 100 --k 100 --index-string PQ${CONFIG}np\
    #   --results answer_pro/SEISMIC1M_${TYPE}${CONFIG}_cluster${CLUSTER}\
    #   --dataset $SEISMIC_DATASET_PATH/seismic_data.bin\
    #   --queries $SEISMIC_DATASET_PATH/seismic_queries.bin\
    #   --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    #   --visit ${VISIT} --is-opq $ISOPQ --budget ${BUDGET}
    for C in 128 512 1024 2048; do
      for V in 500 250 100 050 025 010; do
        python3 compute_accuracy.py answer_pro/SEISMIC1M_${TYPE}${CONFIG}_cluster${CLUSTER}_cluster${C}_V0.${V}000.csv groundtruth_1M_seismic.csv
      done
    done
  }

  CLUSTER="128,512,1024,2048"
  run_seismic PQ 256 32x8 $CLUSTER 32
  # run_seismic PQ 128 16x8 $CLUSTER 16
  run_seismic OPQ 256 32x8 $CLUSTER 32
  # run_seismic OPQ 128 16x8 $CLUSTER 16
elif [ "$1" = "DEEP" ]; then
  run_deep()
  {
    TYPE=$1
    BUDGET=$2
    CONFIG=$3
    CLUSTER=$4
    SEGMENT=$5
    if [ "$TYPE" = "OPQ" ]; then 
      ISOPQ=1
    else 
      ISOPQ=0
    fi
    # ./demos/demo_pro --timeseries-size 96 --dataset-size 1000000\
    #   --queries-size 100 --k 100 --index-string PQ${CONFIG}np\
    #   --results answer_pro/DEEP1M_${TYPE}${CONFIG}_cluster${CLUSTER}\
    #   --dataset $DEEP1B_DATASET_PATH/deep1b_data.bin\
    #   --queries $DEEP1B_DATASET_PATH/deep1b_queries.bin\
    #   --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    #   --visit 0.5,0.25,0.1,0.05,0.025,0.01 --is-opq $ISOPQ --budget ${BUDGET}
    for C in 128 512 1024 2048; do
      for V in 500 250 100 050 025 010; do
        python3 compute_accuracy.py answer_pro/DEEP1M_${TYPE}${CONFIG}_cluster${CLUSTER}_cluster${C}_V0.${V}000.csv groundtruth_1M_deep1b.csv
      done
    done
  }

  CLUSTER="128,512,1024,2048"
  run_deep PQ 256 32x8 $CLUSTER 32
  # run_deep PQ 128 16x8 $CLUSTER 16
  run_deep OPQ 256 32x8 $CLUSTER 32
  # run_deep OPQ 128 16x8 $CLUSTER 16
fi
## OPQ

# ASTRO
# BUDGET=16x8
# for CLUSTER in 128 512 1024; do
#   ./demos/demo_pro --timeseries-size 256 --dataset-size 1000000\
#     --queries-size 100 --k 100 --index-string PQ${BUDGET}np\
#     --results answer_pro/ASTRO1M_PQ${BUDGET}_cluster${CLUSTER}\
#     --dataset $ASTRO_DATASET_PATH/astro_data.bin\
#     --queries $ASTRO_DATASET_PATH/astro_queries.bin\
#     --pro-cluster ${CLUSTER} --visit 0.5,0.25,0.1,0.05
#   for V in 50 25 10 05; do 
#     python3 compute_accuracy.py answer_pro/ASTRO1M_PQ${BUDGET}_cluster${CLUSTER}_V0.${V}0000.csv groundtruth_1M_astro.csv
#   done
# done