#run_flat.sh
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

ANNBENCH_PATH=/mnt/hdd-2T-1/ikraduya/ANN_BENCH
FASHION_GROUND=$ANNBENCH_PATH/FASHION/fashion_groundtruth.csv
KOSARAK_GROUND=$ANNBENCH_PATH/KOSARAK/kosarak_groundtruth.csv
LASTFM_GROUND=$ANNBENCH_PATH/LASTFM/lastfm_groundtruth.csv
NYTIMES_GROUND=$ANNBENCH_PATH/NYTIMES/nytimes_groundtruth.csv

run_one()
{
  DSET=$1
  GROUND=${DSET}_GROUND
  ./run_faiss2.sh Flat $DSET
  cp answer/${DSET}_Flat.csv ${!GROUND}
}

# run_one GLOVE
# run_one CIFAR
# run_one ENRON
# run_one IMAGENET
# run_one MNIST
# run_one MSONG
# run_one NOTRE &
# run_one NUSW &
# run_one SUN &
# run_one TREVI &
#run_one UKBENCH &
run_one FASHION &
run_one KOSARAK &
run_one LASTFM &
run_one NYTIMES &
wait
