ANNBENCH_PATH=/mnt/hdd-2T-1/ikraduya/ANN_BENCH
FASHION_GROUND=$ANNBENCH_PATH/FASHION/fashion_groundtruth.csv
KOSARAK_GROUND=$ANNBENCH_PATH/KOSARAK/kosarak_groundtruth.csv
LASTFM_GROUND=$ANNBENCH_PATH/LASTFM/lastfm_groundtruth.csv
NYTIMES_GROUND=$ANNBENCH_PATH/NYTIMES/nytimes_groundtruth.csv

run_basic()
{
  DSET_NAME=$1
  TYPE=$2; BUDGET=$3
  CONFIG=$4; CLUSTER=$5
  SEGMENT=$6; TSSIZE=$7
  DATASET=$8; QUERIES=$9
  DATASET_SIZE=${10}; QUERIES_SIZE=${11}
  GROUND=${12}; K=${13};
  if [ "$TYPE" = "OPQ" ]; then 
    ISOPQ=1
  else 
    ISOPQ=0
  fi
  VISIT="0.5,0.25,0.1"

  ./demos/demo_pro --timeseries-size ${TSSIZE} --dataset-size ${DATASET_SIZE}\
    --queries-size ${QUERIES_SIZE} --k ${K} --index-string PQ${CONFIG}np\
    --results answer_pro/${DSET_NAME}_${TYPE}${CONFIG}\
    --dataset ${DATASET} --queries ${QUERIES}\
    --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    --visit ${VISIT} --is-opq $ISOPQ --budget ${BUDGET}
  # for V in 500 250 100; do 
  #   python3 compute_accuracy.py answer_pro/${DSET_NAME}_${TYPE}${CONFIG}_cluster${CLUSTER}_V0.${V}000.csv ${GROUND}
  # done
}

full_set_small()
{
  DSET_NAME=$1; TSSIZE=$2
  DATASET=$3; QUERIES=$4
  DATASET_SIZE=$5; QUERIES_SIZE=$6
  GROUND=$7; K=$8;

  CLUSTER="16,32,64,128"
  run_basic ${DSET_NAME} PQ 256 32x8 ${CLUSTER} 32 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K
  run_basic ${DSET_NAME} PQ 128 16x8 ${CLUSTER} 16 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K
  run_basic ${DSET_NAME} OPQ 256 32x8 ${CLUSTER} 32 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K
  run_basic ${DSET_NAME} OPQ 128 16x8 ${CLUSTER} 16 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K
}

if [ "$1" = "FASHION" ]; then
  full_set_small FASHION 784\
    $ANNBENCH_PATH/FASHION/fashion_data.bin $ANNBENCH_PATH/FASHION/fashion_query.bin\
    60000 500 $FASHION_GROUND 100
elif [ "$1" = "KOSARAK" ]; then
  full_set_small KOSARAK 74962\
    $ANNBENCH_PATH/KOSARAK/kosarak_data.bin $ANNBENCH_PATH/KOSARAK/kosarak_query.bin\
    27983 500 $KOSARAK_GROUND 100
elif [ "$1" = "LASTFM" ]; then
  full_set_small LASTFM 65\
    $ANNBENCH_PATH/LASTFM/lastfm_data.bin $ANNBENCH_PATH/LASTFM/lastfm_query.bin\
    292385 500 $LASTFM_GROUND 100
elif [ "$1" = "NYTIMES" ]; then
  full_set_small NYTIMES 256\
    $ANNBENCH_PATH/NYTIMES/nytimes_data.bin $ANNBENCH_PATH/NYTIMES/nytimes_query.bin\
    290000 500 $NYTIMES_GROUND 100
fi
