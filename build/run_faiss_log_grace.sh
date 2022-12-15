#!/bin/sh
# Lernaean hydra datasets
ASTRO_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/ASTRO
SEISMIC_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/SEISMIC
SALD_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/SALD
DEEP1B_DATASET_PATH=/mnt/hdd-2T-1/ikraduya/DEEP1B
SIFT1B_DATASET_PATH=/mnt/hdd-2T-4/ikraduya/SIFT1B

# ANN-Benchmark datasets
GIST_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/GIST
GLOVE_DATASET_PATH=/mnt/hdd-2T-3/ikraduya/GLOVE

# NNS-Benchmark datasets
NNSBENCH_PATH=/mnt/hdd-2T-1/ikraduya/NNS_BENCH
# AUDIO, ENRON, IMAGENET, MNIST, MSONG, NOTRE,
# NUSW, SUN397, TREVI, UKBENCH

run_basic()
{
  DIMENSION=$1
  DATASET_SIZE=$2
  QUERIES_SIZE=$3
  INDEX=$4
  DATASET_PATH=$5
  QUERIES_PATH=$6
  ANSWER_PATH=$7
  K=$8
  LOG=$9
  EFS=${10}
  EFC=${11}

  echo "./demos/demo_ikra --timeseries-size ${DIMENSION}\
            --dataset-size ${DATASET_SIZE} --queries-size ${QUERIES_SIZE}\
            --index-string ${INDEX} --results ${ANSWER_PATH}\
            --dataset ${DATASET_PATH} --queries ${QUERIES_PATH}\
            --k $K --log-file $LOG --ef-search ${EFS}  --ef-construction ${EFC}"

  ./demos/demo_ikra --timeseries-size ${DIMENSION}\
    --dataset-size ${DATASET_SIZE} --queries-size ${QUERIES_SIZE}\
    --index-string ${INDEX} --results ${ANSWER_PATH}\
    --dataset ${DATASET_PATH} --queries ${QUERIES_PATH}\
    --k $K --log-file $LOG  --ef-search ${EFS}  --ef-construction ${EFC}
}

LOGFILE=$4
INDEX=$1
EFC=$5
EFS=$6
# Hydra datasets
if [ "$2" = "ASTRO" ]; then
  if [ "$3" = "100M" ]; then
    DATASET_SIZE=100000000; DATASET_SIZE_H=100M
  elif [ "$3" = "1M" ]; then
    DATASET_SIZE=1000000; DATASET_SIZE_H=1M
  fi
  run_basic 256 $DATASET_SIZE 100 $INDEX\
    $ASTRO_DATASET_PATH/astro_data.bin $ASTRO_DATASET_PATH/astro_queries.bin\
    "answer/ASTRO_${DATASET_SIZE_H}_${INDEX}_efc${EFC}efs${EFS}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "SEISMIC" ]; then
  if [ "$3" = "100M" ]; then
    DATASET_SIZE=99999954; DATASET_SIZE_H=100M
  elif [ "$3" = "1M" ]; then
    DATASET_SIZE=1000000; DATASET_SIZE_H=1M
  fi
  run_basic 256 $DATASET_SIZE 100 $INDEX\
    $SEISMIC_DATASET_PATH/seismic_data.bin $SEISMIC_DATASET_PATH/seismic_queries.bin\
    "answer/SEISMIC_${DATASET_SIZE_H}_${INDEX}_efc${EFC}efs${EFS}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "SALD" ]; then
  if [ "$3" = "100M" ]; then
    DATASET_SIZE=100000000; DATASET_SIZE_H=100M
  elif [ "$3" = "1M" ]; then
    DATASET_SIZE=1000000; DATASET_SIZE_H=1M
  fi
  run_basic 128 $DATASET_SIZE 100 $INDEX\
    $SALD_DATASET_PATH/sald_data.bin $SALD_DATASET_PATH/sald_queries.bin\
    "answer/SALD_${DATASET_SIZE_H}_${INDEX}_efc${EFC}efs${EFS}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "DEEP" ]; then
  if [ "$3" = "100M" ]; then
    DATASET_SIZE=100000000; DATASET_SIZE_H=100M
  elif [ "$3" = "1M" ]; then
    DATASET_SIZE=1000000; DATASET_SIZE_H=1M
  fi
  run_basic 96 $DATASET_SIZE 100 $INDEX\
    $DEEP1B_DATASET_PATH/deep1b_data.bin $DEEP1B_DATASET_PATH/deep1b_queries.bin\
    "answer/DEEP_${DATASET_SIZE_H}_${INDEX}_efc${EFC}efs${EFS}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "SIFT" ]; then
  if [ "$3" = "100M" ]; then
    DATASET_SIZE=100000000; DATASET_SIZE_H=100M
  elif [ "$3" = "1M" ]; then
    DATASET_SIZE=1000000; DATASET_SIZE_H=1M
  fi
  run_basic 128 $DATASET_SIZE 100 $INDEX\
    $SIFT1B_DATASET_PATH/sift1b_data.bin $SIFT1B_DATASET_PATH/sift1b_queries.bin\
    "answer/SIFT_${DATASET_SIZE_H}_${INDEX}_efc${EFC}efs${EFS}.csv" 100 $LOGFILE ${EFS} ${EFC}
# ANNBenchmark datasets
elif [ "$2" = "GIST" ]; then
  run_basic 960 1000000 100 $INDEX\
    $GIST_DATASET_PATH/gist_data.bin $GIST_DATASET_PATH/gist_queries.bin\
    "answer/GIST_${INDEX}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "GLOVE" ]; then
  run_basic 200 1193514 100 $INDEX\
    $GLOVE_DATASET_PATH/glove_data.bin $GLOVE_DATASET_PATH/glove_queries.bin\
    "answer/GLOVE_${INDEX}.csv" 100 $LOGFILE ${EFS} ${EFC}
# NNSBenchmark datasets
elif [ "$2" = "AUDIO" ]; then
  run_basic 192 53387 200 $INDEX\
    $NNSBENCH_PATH/AUDIO/audio_data.bin $NNSBENCH_PATH/AUDIO/audio_query.bin\
    "answer/AUDIO_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "CIFAR" ]; then
  run_basic 512 50000 200 $INDEX\
    $NNSBENCH_PATH/CIFAR/cifar_data.bin $NNSBENCH_PATH/CIFAR/cifar_query.bin\
    "answer/CIFAR_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "ENRON" ]; then
  # ! Pad1376,PQ32x8
  run_basic 1369 94987 200 $INDEX\
    $NNSBENCH_PATH/ENRON/enron_data.bin $NNSBENCH_PATH/ENRON/enron_query.bin\
    "answer/ENRON_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "IMAGENET" ]; then
  run_basic 150 2340373 200 $INDEX\
    $NNSBENCH_PATH/IMAGENET/imagenet_data.bin $NNSBENCH_PATH/IMAGENET/imagenet_query.bin\
    "answer/IMAGENET_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "MNIST" ]; then
  run_basic 784 69000 200 $INDEX\
    $NNSBENCH_PATH/MNIST/mnist_data.bin $NNSBENCH_PATH/MNIST/mnist_query.bin\
    "answer/MNIST_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "MSONG" ]; then
  run_basic 420 992272 200 $INDEX\
    $NNSBENCH_PATH/MSONG/msong_data.bin $NNSBENCH_PATH/MSONG/msong_query.bin\
    "answer/MSONG_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "NOTRE" ]; then
  run_basic 128 332668 200 $INDEX\
    $NNSBENCH_PATH/NOTRE/notre_data.bin $NNSBENCH_PATH/NOTRE/notre_query.bin\
    "answer/NOTRE_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "NUSW" ]; then
  run_basic 500 268643 200 $INDEX\
    $NNSBENCH_PATH/NUSW/nusw_data.bin $NNSBENCH_PATH/NUSW/nusw_query.bin\
    "answer/NUSW_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "SUN" ]; then
  run_basic 512 79106 200 $INDEX\
    $NNSBENCH_PATH/SUN397/sun_data.bin $NNSBENCH_PATH/SUN397/sun_query.bin\
    "answer/SUN_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "TREVI" ]; then
 run_basic 4096 99900 200 $INDEX\
    $NNSBENCH_PATH/TREVI/trevi_data.bin $NNSBENCH_PATH/TREVI/trevi_query.bin\
    "answer/TREVI_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "UKBENCH" ]; then
  run_basic 128 1097907 200 $INDEX\
    $NNSBENCH_PATH/UKBENCH/ukbench_data.bin $NNSBENCH_PATH/UKBENCH/ukbench_query.bin\
    "answer/UKBENCH_${INDEX}.csv" 20 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "FASHION" ]; then
  ANNBENCH_PATH=/mnt/hdd-2T-1/ikraduya/ANN_BENCH
  run_basic 784 60000 500 $INDEX\
    $ANNBENCH_PATH/FASHION/fashion_data.bin $ANNBENCH_PATH/FASHION/fashion_query.bin\
    "answer/FASHION_${INDEX}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "KOSARAK" ]; then
  ANNBENCH_PATH=/mnt/hdd-2T-1/ikraduya/ANN_BENCH
  run_basic 74962 27983 500 $INDEX\
    $ANNBENCH_PATH/KOSARAK/kosarak_data.bin $ANNBENCH_PATH/KOSARAK/kosarak_query.bin\
    "answer/KOSARAK_${INDEX}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "LASTFM" ]; then
  ANNBENCH_PATH=/mnt/hdd-2T-1/ikraduya/ANN_BENCH
  run_basic 65 292385 500 $INDEX\
    $ANNBENCH_PATH/LASTFM/lastfm_data.bin $ANNBENCH_PATH/LASTFM/lastfm_query.bin\
    "answer/LASTFM_${INDEX}.csv" 100 $LOGFILE ${EFS} ${EFC}
elif [ "$2" = "NYTIMES" ]; then
  ANNBENCH_PATH=/mnt/hdd-2T-1/ikraduya/ANN_BENCH
  run_basic 256 290000 500 $INDEX\
    $ANNBENCH_PATH/NYTIMES/nytimes_data.bin $ANNBENCH_PATH/NYTIMES/nytimes_query.bin\
    "answer/NYTIMES_${INDEX}.csv" 100 $LOGFILE ${EFS} ${EFC}
fi
