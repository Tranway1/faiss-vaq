#run_pq.sh
GIST_GROUND=groundtruth_1M_gist.csv
GLOVE_GROUND=groundtruth_1M_glove.csv
NNSBENCH_PATH=/mnt/hdd-2T-1/ikraduya/NNS_BENCH
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

OUTFILE=$3

run_one()
{
  INDEX=$1
  DSET=$2
  GROUND=${DSET}_GROUND
  echo -ne "${DSET}," >> $OUTFILE
  # ./run_faiss2.sh $INDEX $DSET
  python3 compute_accuracy.py answer/${DSET}_${INDEX}.csv ${!GROUND} >> $OUTFILE
}

echo "Dataset,Training,Encoding,Query,Precision,Recall,MAP" >> $OUTFILE
if [ "$1" = "PQ" ]; then
  if [ "$2" = "32x8" ]; then
    run_one PQ32x8np GIST
    run_one Pad224,PQ32x8np GLOVE
    run_one PQ32x8np AUDIO
    run_one PQ32x8np CIFAR
    run_one Pad1376,PQ32x8np ENRON
    run_one Pad160,PQ32x8np IMAGENET
    run_one Pad800,PQ32x8np MNIST
    run_one Pad448,PQ32x8np MSONG
    run_one PQ32x8np NOTRE
    run_one Pad512,PQ32x8np NUSW
    run_one PQ32x8np SUN
    run_one PQ32x8np TREVI
    run_one PQ32x8np UKBENCH
  elif [ "$2" = "64x4" ]; then
    run_one PQ64x4np GIST
    run_one Pad256,PQ64x4np GLOVE
    run_one PQ64x4np AUDIO
    run_one PQ64x4np CIFAR
    run_one Pad1408,PQ64x4np ENRON
    run_one Pad192,PQ64x4np IMAGENET
    run_one Pad832,PQ64x4np MNIST
    run_one Pad448,PQ64x4np MSONG
    run_one PQ64x4np NOTRE
    run_one Pad512,PQ64x4np NUSW
    run_one PQ64x4np SUN
    run_one PQ64x4np TREVI
    run_one PQ64x4np UKBENCH
  elif [ "$2" = "16x8" ]; then
    run_one PQ16x8np GIST
    run_one Pad208,PQ16x8np GLOVE
    run_one PQ16x8np AUDIO
    run_one PQ16x8np CIFAR
    run_one Pad1376,PQ16x8np ENRON
    run_one Pad160,PQ16x8np IMAGENET
    run_one PQ16x8np MNIST
    run_one Pad432,PQ16x8np MSONG
    run_one PQ16x8np NOTRE
    run_one Pad512,PQ16x8np NUSW
    run_one PQ16x8np SUN
    run_one PQ16x8np TREVI
    run_one PQ16x8np UKBENCH
  elif [ "$2" = "32x4" ]; then
    run_one PQ32x4np GIST
    run_one Pad224,PQ32x4np GLOVE
    run_one PQ32x4np AUDIO
    run_one PQ32x4np CIFAR
    run_one Pad1376,PQ32x4np ENRON
    run_one Pad160,PQ32x4np IMAGENET
    run_one Pad800,PQ32x4np MNIST
    run_one Pad448,PQ32x4np MSONG
    run_one PQ32x4np NOTRE
    run_one Pad512,PQ32x4np NUSW
    run_one PQ32x4np SUN
    run_one PQ32x4np TREVI
    run_one PQ32x4np UKBENCH
  fi
elif [ "$1" = "OPQ" ]; then
  if [ "$2" = "32x8" ]; then
    run_one OPQ32,PQ32x8np GIST
    run_one Pad224,OPQ32,PQ32x8np GLOVE
    run_one OPQ32,PQ32x8np AUDIO
    run_one OPQ32,PQ32x8np CIFAR
    run_one Pad1376,OPQ32,PQ32x8np ENRON
    run_one Pad160,OPQ32,PQ32x8np IMAGENET
    run_one Pad800,OPQ32,PQ32x8np MNIST
    run_one Pad448,OPQ32,PQ32x8np MSONG
    run_one OPQ32,PQ32x8np NOTRE
    run_one Pad512,OPQ32,PQ32x8np NUSW
    run_one OPQ32,PQ32x8np SUN
    run_one OPQ32,PQ32x8np TREVI
    run_one OPQ32,PQ32x8np UKBENCH
  elif [ "$2" = "64x4" ]; then
    run_one OPQ64,PQ64x4np GIST
    run_one Pad256,OPQ64,PQ64x4np GLOVE
    run_one OPQ64,PQ64x4np AUDIO
    run_one OPQ64,PQ64x4np CIFAR
    run_one Pad1408,OPQ64,PQ64x4np ENRON
    run_one Pad192,OPQ64,PQ64x4np IMAGENET
    run_one Pad832,OPQ64,PQ64x4np MNIST
    run_one Pad448,OPQ64,PQ64x4np MSONG
    run_one OPQ64,PQ64x4np NOTRE
    run_one Pad512,OPQ64,PQ64x4np NUSW
    run_one OPQ64,PQ64x4np SUN
    run_one OPQ64,PQ64x4np TREVI
    run_one OPQ64,PQ64x4np UKBENCH
  elif [ "$2" = "16x8" ]; then
    run_one OPQ16,PQ16x8np GIST
    run_one Pad208,OPQ16,PQ16x8np GLOVE
    run_one OPQ16,PQ16x8np AUDIO
    run_one OPQ16,PQ16x8np CIFAR
    run_one Pad1376,OPQ16,PQ16x8np ENRON
    run_one Pad160,OPQ16,PQ16x8np IMAGENET
    run_one OPQ16,PQ16x8np MNIST
    run_one Pad432,OPQ16,PQ16x8np MSONG
    run_one OPQ16,PQ16x8np NOTRE
    run_one Pad512,OPQ16,PQ16x8np NUSW
    run_one OPQ16,PQ16x8np SUN
    run_one OPQ16,PQ16x8np TREVI
    run_one OPQ16,PQ16x8np UKBENCH
  elif [ "$2" = "32x4" ]; then
    run_one OPQ32,PQ32x4np GIST
    run_one Pad224,OPQ32,PQ32x4np GLOVE
    run_one OPQ32,PQ32x4np AUDIO
    run_one OPQ32,PQ32x4np CIFAR
    run_one Pad1376,OPQ32,PQ32x4np ENRON
    run_one Pad160,OPQ32,PQ32x4np IMAGENET
    run_one Pad800,OPQ32,PQ32x4np MNIST
    run_one Pad448,OPQ32,PQ32x4np MSONG
    run_one OPQ32,PQ32x4np NOTRE
    run_one Pad512,OPQ32,PQ32x4np NUSW
    run_one OPQ32,PQ32x4np SUN
    run_one OPQ32,PQ32x4np TREVI
    run_one OPQ32,PQ32x4np UKBENCH
  fi
elif [ "$1" = "HNSW" ]; then
  LINK=$2
  run_one HNSW${LINK},Flat GIST
  run_one HNSW${LINK},Flat GLOVE
  run_one HNSW${LINK},Flat AUDIO
  run_one HNSW${LINK},Flat CIFAR
  run_one HNSW${LINK},Flat ENRON
  run_one HNSW${LINK},Flat IMAGENET
  run_one HNSW${LINK},Flat MNIST
  run_one HNSW${LINK},Flat MSONG
  run_one HNSW${LINK},Flat NOTRE
  run_one HNSW${LINK},Flat NUSW
  run_one HNSW${LINK},Flat SUN
  run_one HNSW${LINK},Flat TREVI
  run_one HNSW${LINK},Flat UKBENCH
elif [ "$1" = "LSH" ]; then
  run_one LSHrt GIST
  run_one LSHrt GLOVE
  run_one LSHrt AUDIO
  run_one LSHrt CIFAR
  run_one LSHrt ENRON
  run_one LSHrt IMAGENET
  run_one LSHrt MNIST
  run_one LSHrt MSONG
  run_one LSHrt NOTRE
  run_one LSHrt NUSW
  run_one LSHrt SUN
  run_one LSHrt TREVI
  run_one LSHrt UKBENCH
  run_one ITQ,LSHrt GIST
  run_one ITQ,LSHrt GLOVE
  run_one ITQ,LSHrt AUDIO
  run_one ITQ,LSHrt CIFAR
  run_one ITQ,LSHrt ENRON
  run_one ITQ,LSHrt IMAGENET
  run_one ITQ,LSHrt MNIST
  run_one ITQ,LSHrt MSONG
  run_one ITQ,LSHrt NOTRE
  run_one ITQ,LSHrt NUSW
  run_one ITQ,LSHrt SUN
  run_one ITQ,LSHrt TREVI
  run_one ITQ,LSHrt UKBENCH
fi
