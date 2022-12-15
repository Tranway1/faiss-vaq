# ANN-Benchmark datasets
GIST_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/GIST
GLOVE_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/GLOVE

# NNS-Benchmark datasets
NNSBENCH_PATH=/mnt/hdd-2T-1/ikraduya/NNS_BENCH
# AUDIO, ENRON, IMAGENET, MNIST, MSONG, NOTRE,
# NUSW, SUN397, TREVI, UKBENCH
AUDIO_GROUND=$NNSBENCH_PATH/AUDIO/audio_groundtruth.csv
CIFAR_GROUND=$NNSBENCH_PATH/CIFAR/cifar_groundtruth.csv
ENRON_GROUND=$NNSBENCH_PATH/ENRON/enron_groundtruth.csv
IMAGENET_GROUND=$NNSBENCH_PATH/IMAGENET/imagenet_groundtruth.csv
MNIST_GROUND=$NNSBENCH_PATH/MNIST/mnist_groundtruth.csv
MSONG_GROUND=$NNSBENCH_PATH/MSONG/msong_groundtruth.csv
NOTRE_GROUND=$NNSBENCH_PATH/NOTRE/notre_groundtruth.csv
NUSW_GROUND=$NNSBENCH_PATH/NUSW/nusw_groundtruth.csv
SUN_GROUND=$NNSBENCH_PATH/SUN397/sun_groundtruth.csv
TREVI_GROUND=$NNSBENCH_PATH/TREVI/trevi_groundtruth.csv
UKBENCH_GROUND=$NNSBENCH_PATH/UKBENCH/ukbench_groundtruth.csv

run_basic()
{
  DSET_NAME=$1
  TYPE=$2; BUDGET=$3
  CONFIG=$4; CLUSTER=$5
  SEGMENT=$6; TSSIZE=$7
  DATASET=$8; QUERIES=$9
  DATASET_SIZE=${10}; QUERIES_SIZE=${11}
  GROUND=${12}; K=${13}; ISBIG=${14}
  if [ "$TYPE" = "OPQ" ]; then 
    ISOPQ=1
  else 
    ISOPQ=0
  fi
  if [ "$ISBIG" = "1" ]; then 
    VISIT="0.5,0.25,0.1,0.05,0.025,0.01"
  else 
    VISIT="0.5,0.25,0.1"
  fi

  ./demos/demo_pro --timeseries-size ${TSSIZE} --dataset-size ${DATASET_SIZE}\
    --queries-size ${QUERIES_SIZE} --k ${K} --index-string PQ${CONFIG}np\
    --results answer_pro/${DSET_NAME}_${TYPE}${CONFIG}_cluster${CLUSTER}\
    --dataset ${DATASET} --queries ${QUERIES}\
    --pro-cluster ${CLUSTER} --opq-segment ${SEGMENT}\
    --visit ${VISIT} --is-opq $ISOPQ --budget ${BUDGET}
  # if [ "$ISBIG" = "1" ]; then 
  #   for V in 500 250 100 050 025 010; do 
  #     python3 compute_accuracy.py answer_pro/${DSET_NAME}_${TYPE}${CONFIG}_cluster${CLUSTER}_V0.${V}000.csv ${GROUND}
  #   done
  # else 
  #   for V in 500 250 100; do 
  #     python3 compute_accuracy.py answer_pro/${DSET_NAME}_${TYPE}${CONFIG}_cluster${CLUSTER}_V0.${V}000.csv ${GROUND}
  #   done
  # fi
}

full_set_big()
{
  DSET_NAME=$1; TSSIZE=$2
  DATASET=$3; QUERIES=$4
  DATASET_SIZE=$5; QUERIES_SIZE=$6
  GROUND=$7; K=$8; ISBIG=1

  CLUSTER="128,512,1024,2048"
  run_basic ${DSET_NAME} PQ 256 32x8 ${CLUSTER} 32 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
  run_basic ${DSET_NAME} PQ 128 16x8 ${CLUSTER} 16 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
  run_basic ${DSET_NAME} OPQ 256 32x8 ${CLUSTER} 32 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
  run_basic ${DSET_NAME} OPQ 128 16x8 ${CLUSTER} 16 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
}

full_set_small()
{
  DSET_NAME=$1; TSSIZE=$2
  DATASET=$3; QUERIES=$4
  DATASET_SIZE=$5; QUERIES_SIZE=$6
  GROUND=$7; K=$8; ISBIG=0

  CLUSTER="16,32,64,128"
  run_basic ${DSET_NAME} PQ 256 32x8 ${CLUSTER} 32 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
  run_basic ${DSET_NAME} PQ 128 16x8 ${CLUSTER} 16 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
  run_basic ${DSET_NAME} OPQ 256 32x8 ${CLUSTER} 32 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
  run_basic ${DSET_NAME} OPQ 128 16x8 ${CLUSTER} 16 $TSSIZE\
    $DATASET $QUERIES $DATASET_SIZE $QUERIES_SIZE $GROUND $K $ISBIG
}

if [ "$1" = "GLOVE" ]; then
  full_set_big GLOVE 200\
    $GLOVE_DATASET_PATH/glove_data.bin $GLOVE_DATASET_PATH/glove_queries.bin\
    1193514 100 groundtruth_1M_glove.csv 100
elif [ "$1" = "ENRON" ]; then
  full_set_small ENRON 1369\
    $NNSBENCH_PATH/ENRON/enron_data.bin $NNSBENCH_PATH/ENRON/enron_query.bin\
    94987 200 ${ENRON_GROUND} 20
elif [ "$1" = "IMAGENET" ]; then
  full_set_big IMAGENET 150\
    $NNSBENCH_PATH/IMAGENET/imagenet_data.bin $NNSBENCH_PATH/IMAGENET/imagenet_query.bin\
    2340373 200 ${IMAGENET_GROUND} 20
elif [ "$1" = "MNIST" ]; then
  full_set_small MNIST 784\
    $NNSBENCH_PATH/MNIST/mnist_data.bin $NNSBENCH_PATH/MNIST/mnist_query.bin\
    69000 200 ${MNIST_GROUND} 20
elif [ "$1" = "MSONG" ]; then
  full_set_big SUN 420\
    $NNSBENCH_PATH/MSONG/msong_data.bin $NNSBENCH_PATH/MSONG/msong_query.bin\
    992272 200 ${MSONG_GROUND} 20
elif [ "$1" = "NUSW" ]; then
  full_set_small NUSW 500\
    $NNSBENCH_PATH/NUSW/nusw_data.bin $NNSBENCH_PATH/NUSW/nusw_query.bin\
    268643 200 ${NUSW_GROUND} 20
fi
