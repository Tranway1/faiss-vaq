# (./run_faiss_log_grace.sh HNSW32,PQ32x8np SALD 100M "log" > log_base/SALD100M_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np DEEP 100M "log" > log_base/DEEP100M_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np ASTRO 1M "log" > log_base/ASTRO1M_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np SEISMIC 1M "log" > log_base/SEISMIC1M_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np GIST dum "log" > log_base/GIST_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad224,HNSW32,PQ32x8np GLOVE dum "log" > log_base/GLOVE_HNSW32,PQ32x8np.txt) &
# wait
# ./notifyscript.sh "hnsw hydra db 100M done"
# make demo_ikra

# (./run_faiss_log_grace.sh HNSW32,PQ32x8np AUDIO dum "log" > log_base/AUDIO_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np CIFAR dum "log" > log_base/CIFAR_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad1376,HNSW32,PQ32x8np ENRON dum "log" > log_base/ENRON_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad160,HNSW32,PQ32x8np IMAGENET dum "log" > log_base/IMAGENET_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad800,HNSW32,PQ32x8np MNIST dum "log" > log_base/MNIST_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad448,HNSW32,PQ32x8np MSONG dum "log" > log_base/MSONG_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np NOTRE dum "log" > log_base/NOTRE_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad512,HNSW32,PQ32x8np NUSW dum "log" > log_base/NUSW_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np SUN dum "log" > log_base/SUN_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np TREVI dum "log" > log_base/TREVI_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np UKBENCH dum "log" > log_base/UKBENCH_HNSW32,PQ32x8np.txt) &
# wait
# ./notifyscript.sh "hnsw nns db done"

(./run_faiss_log.sh HNSW32,Flat AUDIO dum "log" > log_base/AUDIO_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat CIFAR dum "log" > log_base/CIFAR_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat ENRON dum "log" > log_base/ENRON_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat IMAGENET dum "log" > log_base/IMAGENET_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat MNIST dum "log" > log_base/MNIST_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat MSONG dum "log" > log_base/MSONG_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat NOTRE dum "log" > log_base/NOTRE_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat NUSW dum "log" > log_base/NUSW_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat SUN dum "log" > log_base/SUN_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat TREVI dum "log" > log_base/TREVI_HNSW32,Flat.txt) &
(./run_faiss_log.sh HNSW32,Flat UKBENCH dum "log" > log_base/UKBENCH_HNSW32,Flat.txt) &
wait
./notifyscript.sh "hnsw nns db done"

# (./run_faiss_log_grace.sh Pad800,HNSW32,PQ32x8np FASHION dum "log" > log_base/FASHION_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad74976,HNSW32,PQ32x8np KOSARAK dum "log" > log_base/KOSARAK_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh Pad96,HNSW32,PQ32x8np LASTFM dum "log" > log_base/LASTFM_HNSW32,PQ32x8np.txt) &
# (./run_faiss_log_grace.sh HNSW32,PQ32x8np NYTIMES dum "log" > log_base/NYTIMES_HNSW32,PQ32x8np.txt) &
# wait
# ./notifyscript.sh "hnsw ann db done"



# ./run_faiss_log_grace.sh OPQ32,IMI2x2,PQ32x8np SIFT 100M answer_base/SIFT100M_OPQ32,IMI2x2,PQ32x8np.txt > log_base/SIFT100M_OPQ32,IMI2x2,PQ32x8np.txt && ./notifyscript.sh "sift100m imi2x2,opq done"
# (./run_faiss_log_grace.sh OPQ32,IMI2x2,PQ32x8np SALD 100M answer_base/SALD100M_OPQ32,IMI2x2,PQ32x8np.txt > log_base/SALD100M_OPQ32,IMI2x2,PQ32x8np.txt && ./notifyscript.sh "sald100m imi2x2,opq done") &
# (./run_faiss_log_grace.sh OPQ32,IMI2x2,PQ32x8np DEEP 100M answer_base/DEEP100M_OPQ32,IMI2x2,PQ32x8np.txt > log_base/DEEP100M_OPQ32,IMI2x2,PQ32x8np.txt && ./notifyscript.sh "deep100m imi2x2,opq done") &
# wait
# ./run_faiss_log_grace.sh OPQ32,IMI2x2,PQ32x8np ASTRO 100M answer_base/ASTRO100M_OPQ32,IMI2x2,PQ32x8np.txt > log_base/ASTRO100M_OPQ32,IMI2x2,PQ32x8np.txt && ./notifyscript.sh "astro100m imi2x2,opq done"
# ./run_faiss_log_grace.sh OPQ32,IMI2x2,PQ32x8np SEISMIC 100M answer_base/SEISMIC100M_OPQ32,IMI2x2,PQ32x8np.txt > log_base/SEISMIC100M_OPQ32,IMI2x2,PQ32x8np.txt && ./notifyscript.sh "seismic100m imi2x2,opq done"
# ./notifyscript.sh "IMI2x2,OPQ 100m datasets done"
