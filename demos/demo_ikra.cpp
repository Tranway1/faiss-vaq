/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */



#include <cmath>
#include <fstream>
#include <cstdio>
#include <sstream>
#include <iostream>
#include <string>
#include <cstdlib>
#include <random>
#include <vector>
#include <getopt.h>
#include <omp.h>
#include <limits>

#include <sys/time.h>
#include <sys/stat.h>


#include <faiss/IndexIVFPQ.h>
#include <faiss/IndexFlat.h>
#include <faiss/IndexHNSW.h>
#include <faiss/IndexPreTransform.h>
#include <faiss/index_io.h>
#include <faiss/index_factory.h>

double elapsed ()
{
    struct timeval tv;
    gettimeofday (&tv, NULL);
    return  tv.tv_sec + tv.tv_usec * 1e-6;
}

void read_data_bin(
    std::string filepath,
    std::vector<float> &data,
    size_t N,  // dimension
    size_t maxRow)
{
    FILE *infile = fopen(filepath.c_str(), "rb");
    if (infile == NULL) {
        std::cout << "File not found" << std::endl;
        return;
    }

    if (fread(data.data(), 1, sizeof(float)*((size_t)N*maxRow), infile) == 0) {
        std::cout << "error while reading file" << std::endl;
    }

    if (fclose(infile)) {
        std::cout << "Could not close data file" << std::endl;
    }

    for (size_t i=0; i<N*maxRow; i++) {
        if (!std::isfinite(data[i])) {
            data[i] = 0;
            // std::cout << "changed to " << data[i] << std::endl;
            // exit(0);
        }
        // std::cout << "luar" << std::endl;
    }
    // std::cout << "sudah di luar" << std::endl;
}

struct Args {
  std::string datasetFilepath = "";
  std::string queriesFilepath = "";
  std::string indexString = "";
  std::string resultsFilepath = "";
  int datasetSize = 0;
//   int refine = 0;
  std::vector<int> refines;
  std::string refinestring = "";
  int queriesSize = 0;
  int N = 1;  // dimension
  std::string fileFormatOri = "fvecs";
  int K = 100;
  int hnswEfSearch = 20;
  int hnswEfConstruction = 20;
  std::string logFile = "temp.log";
} args;

int main (int argc, char **argv)
{
    omp_set_num_threads(1);
    double t0 = elapsed();

    while (true) {
        static struct option long_options[] = {
            {"dataset", required_argument, 0, 'd'},
            {"queries", required_argument, 0, 'q'},
            {"results", required_argument, 0, 'r'},
            {"index-string", required_argument, 0, 'v'},
            {"timeseries-size", required_argument, 0, 't'},
            {"dataset-size", required_argument, 0, 'a'},
            {"queries-size", required_argument, 0, 'u'},
            {"file-format-ori", required_argument, 0, 'z'},
            {"refine", required_argument, 0, 'e'},
            {"k", required_argument, 0, 'k'},
            {"ef-search", required_argument, 0, 'f'},
            {"ef-construction", required_argument, 0, 'c'},
            {"log-file", required_argument, 0, 'g'},
            {"help", no_argument, 0, '?'}
        };
        
        int option_index = 0;
        int raw_method;

        int c = getopt_long (argc, argv, "", long_options, &option_index);
        if (c == -1) break;
        switch (c) {
            case 'd': args.datasetFilepath = optarg; break;
            case 'q': args.queriesFilepath = optarg; break;
            case 'r': args.resultsFilepath = optarg; break;
            case 'v': args.indexString = optarg; break;
            case 't': args.N = std::atoi(optarg); break;
            case 'a': args.datasetSize = std::atoi(optarg); break;
            case 'u': args.queriesSize = std::atoi(optarg); break;
            case 'z': args.fileFormatOri = optarg; break;
            case 'e': args.refinestring = optarg; break;
            case 'k': args.K = std::atoi(optarg); break;
            case 'f': args.hnswEfSearch = std::atoi(optarg); break;
            case 'c': args.hnswEfConstruction = std::atoi(optarg); break;
            case 'g': args.logFile = optarg; break;
            case '?':
                printf( 
                "Usage:\n\
                \t--dataset XX \t\t\tThe path to the dataset file\n\
                \t--queries XX \t\t\tThe path to the queries file\n\
                \t--results XX \t\t\tThe path to the results filepath\n\
                \t--dataset-size XX \t\tThe number of time series to load\n\
                \t--queries-size XX \t\tThe number of queries to run\n\
                \t--timeseries-size XX \t\tThe number of dimension\n\
                \t--index-string XX \t\tThe index factory string\n\
                \t--file-format-ori: \n\
                \t--\tascii\n\
                \t--\tfvecs\n\
                \t--\tbvecs\n\
                \t--\tbin\n\
                \t--k XX\t\tK in K-nearest-neighbor\n\
                \t--refine XX\t\tapply refine after getting XX\n\
                \t--help\n\n\n");
                exit(0);
                break;
        }
    }

    if (args.refinestring != "") {
        std::stringstream ss(args.refinestring);

        while (ss.good()) {
            std::string substr;
            getline( ss, substr, ',' );
            args.refines.push_back(std::stoi(substr));
        }
    } else {
        args.refines.push_back(0);
    }

    // dimension of the vectors to index
    int d = args.N;

    // size of the database we plan to index
    size_t nb = args.datasetSize;

    // make a set of nt training vectors in the unit cube
    // (could be the database)
    size_t nt = args.datasetSize;
    // if (nt > 10000000) {
    //     nt = 10000000;
    // }

    // // make the index object and train it
    // faiss::IndexFlatL2 coarse_quantizer (d);

    // // a reasonable number of centroids to index nb vectors
    // int ncentroids = int (4 * sqrt (nb));

    // // the coarse quantizer should not be dealloced before the index
    // // 4 = nb of bytes per code (d must be a multiple of this)
    // // 8 = nb of bits per sub-code (almost always 8)
    // faiss::IndexIVFPQ index (&coarse_quantizer, d,
    //                          ncentroids, 4, 8);

    // Basic PQ
    // int M = 32;
    // int nbits = 4;
    // faiss::IndexPQ * index = new faiss::IndexPQ(d, M, nbits);
    // faiss::Index * index = faiss::index_factory(d, "PQ32x8np");

    // Basic OPQ
    // int M = 32;
    // int nbits = 8;
    // faiss::Index * index = faiss::index_factory(d, "OPQ8,PQ8x4np");
    
    // Basic IMI
    // int M = 32;
    // int nbits = 8;
    // faiss::Index * index = faiss::index_factory(d, "IMI2x2,PQ32x8np");

    printf("Args:\n");
    printf("\tdimension = %d\n", args.N);
    printf("\tdataset size = %d\n", args.datasetSize);
    printf("\tqueries size = %d\n", args.queriesSize);
    printf("\tdataset filepath = %s\n", args.datasetFilepath.c_str());
    printf("\tqueries filepath = %s\n", args.queriesFilepath.c_str());
    printf("\tresults filepath = %s\n", args.resultsFilepath.c_str());
    printf("\tindex-string: %s\n", args.indexString.c_str());
    printf("\tK: %d\n", args.K);
    printf("\thnswEfSearch: %d\n", args.hnswEfSearch);
    printf("\thnswEfConstruction: %d\n", args.hnswEfConstruction);

    if (args.refinestring != "") {
        printf("\tRefine: %s\n", args.refinestring.c_str());
    }


    faiss::Index * index;
    size_t found = args.datasetFilepath.find_last_of("/\\");
    std::string datasetLastName = args.datasetFilepath.substr(found+1);
    std::string outfilenameIndex = std::string("tmp_idx_faiss/index_trained_") + args.indexString + std::string("_") + datasetLastName + "_" + std::to_string(args.datasetSize) + std::string("_optimized.faissindex");
    auto file_exists = [](const std::string& fname) -> bool{
        struct stat buffer;
        return (stat(fname.c_str(), &buffer) == 0);
    };
    bool indexExists = file_exists(outfilenameIndex);
    // std::string outfilenameIndex = std::string("tmp/index_trained_") + args.indexString + std::string("_") + datasetLastName + "_" + std::to_string(args.datasetSize) + std::string(".faissindex");
    std::ofstream logfile;
    logfile.open(args.logFile, std::ofstream::out | std::ofstream::app);
    { // training & encoding
        if (args.N > 10000) {
            omp_set_num_threads(1);
        }
        std::vector<float> database(nb * d);
        read_data_bin(args.datasetFilepath, database, args.N, nb);

        if (!indexExists || true) { // train index
            std::cout << "training index" << std::endl;
            index = faiss::index_factory(d, args.indexString.c_str());
            if (true) { // HNSW index
                faiss::IndexHNSW *hnswIndex = (faiss::IndexHNSW *)index;
                hnswIndex->hnsw.efSearch = args.hnswEfSearch;
                hnswIndex->hnsw.efConstruction = args.hnswEfConstruction;
            } else if (false) {  // PQ or IMI,PQ
                // faiss::IndexPQ *pqIndex = (faiss::IndexPQ *)index;
                faiss::IndexIVFPQ *pqIndex = (faiss::IndexIVFPQ *)index;
                size_t max_points = static_cast<size_t>(std::ceil(512 * std::sqrt(nt) / 256)); // sqrt(rows)
                if (max_points < pqIndex->pq.cp.min_points_per_centroid) {
                    // max_points = pqIndex->pq.cp.min_points_per_centroid;
                    pqIndex->pq.cp.min_points_per_centroid = max_points;
                    pqIndex->pq.cp.max_points_per_centroid = max_points;
                } else {
                    pqIndex->pq.cp.max_points_per_centroid = max_points;
                }
            } else if (false) {  // OPQ or IMI,OPQ
                faiss::IndexPreTransform *ptIndex = (faiss::IndexPreTransform *)index;
                faiss::IndexPQ *pqIndex = (faiss::IndexPQ *)(ptIndex->index);
                // faiss::IndexIVFPQ *pqIndex = (faiss::IndexIVFPQ *)(ptIndex->index);
                size_t max_points = static_cast<size_t>(std::ceil(512 * std::sqrt(nt) / 256)); // sqrt(rows)
                if (max_points < pqIndex->pq.cp.min_points_per_centroid) {
                    pqIndex->pq.cp.min_points_per_centroid = max_points;
                    pqIndex->pq.cp.max_points_per_centroid = max_points;
                } else {
                    pqIndex->pq.cp.max_points_per_centroid = max_points;
                }

                std::cout << "bener ga nih " << pqIndex->pq.cp.max_points_per_centroid << std::endl;
            }
            printf ("[%.3f s] Training the index\n",
                    elapsed() - t0);
            index->verbose = true;
            double start_time = elapsed(), finish_time;
            // faiss::IndexIVFPQ *pqIndex = (faiss::IndexIVFPQ *)index;
            // std::cout << "max_points_per_centroid: " << pqIndex->pq.cp.max_points_per_centroid;
            if (false) {    // sampled
                std::vector<float> database_sampled(5120000 * d);
                faiss::RandomGenerator rng(1234);
                for (size_t i=0; i<5120000; i++) {
                    size_t rand_idx = rng.rand_int(nt);
                    std::copy(
                        database.data() + (rand_idx * d),
                        database.data() + (rand_idx * d + d),
                        database_sampled.data() + (i * d));
                }
                index->train (5120000, database_sampled.data());
            } else {
                index->train (nb, database.data());
            }
            finish_time = elapsed();
            printf("Training Time: %.4f s\n", finish_time-start_time);
            logfile << finish_time-start_time << ',';
            // exit(0);
            
            // writeout index
            printf ("[%.3f s] storing the pre-trained index to %s\n",
                    elapsed() - t0, outfilenameIndex.c_str());

            write_index (index, outfilenameIndex.c_str());
        }
        else {     // read index
            std::cout << "reading index" << std::endl;
            printf ("[%.3f s] Reading the pre-trainded index from %s\n",
                    elapsed() - t0, outfilenameIndex.c_str());
            index = faiss::read_index(outfilenameIndex.c_str());
        }

        printf ("[%.3f s] Adding the vectors to the index\n",
                elapsed() - t0);

        double start_time = elapsed(), finish_time;
        if (false) {    // batches
            for (size_t i=0; i<10; i++) {
                if (i == 9 && (nb % 10 != 0)) {
                    size_t remainder = nb - ((nb / 10) * 10);
                    index->add(nb / 10 + remainder, database.data() + (nb / 10 * i * d));
                } else {
                    index->add(nb / 10, database.data() + (nb / 10 * i * d));
                }
            }
        } else {
            index->add (nb, database.data());
        }
        finish_time = elapsed();
        printf("Encoding Time: %.4f s\n", finish_time-start_time);
        logfile << finish_time-start_time << ',';
        if (args.N > 10000) {
            omp_set_num_threads(1);
        }
    }

    { 
        omp_set_num_threads(1);
        // searching the database
        size_t nq = args.queriesSize;
        std::vector<float> queries(nq * d);
        read_data_bin(args.queriesFilepath, queries, args.N, nq);
        
        for (const int refine: args.refines) {
            int k = args.K;
            int nnNum = k;
            if (refine > 0 && refine >= k) {
                nnNum = refine;
            }
            printf ("[%.3f s] Searching the %d nearest neighbors "
                    "of %ld vectors in the index\n",
                    elapsed() - t0, k, nq);
            if (nnNum != k) {
                printf ("[%.3f s] Using refine %d\n",
                        elapsed() - t0, nnNum);
            }

            double start_time = elapsed(), finish_time;
            std::vector<faiss::Index::idx_t> nns (nnNum * nq);
            std::vector<float>               dis (nnNum * nq);
            index->search (nq, queries.data(), nnNum, dis.data(), nns.data());
            finish_time = elapsed();
            printf("Query Time: %.4f s\n", finish_time-start_time);
            logfile << finish_time-start_time << ',';

            printf ("[%.3f s] Query results (vector ids, then distances):\n",
                    elapsed() - t0);

            {   
                std::string finalResultsFP = args.resultsFilepath;
                if (args.refines.size() > 1) {
                    finalResultsFP.append("_R" + std::to_string(refine));
                }
                std::ofstream outfile;
                outfile.open(finalResultsFP);

                for (int i = 0; i < nq; i++) {
                    // printf ("query %2d: ", i);
                    for (int j = 0; j < k; j++) {
                        // printf ("%7ld ", nns[j + i * k]);
                        outfile << nns[j + i * nnNum];
                        if (j != k-1) {
                            outfile << ',';
                        }
                    }
                    outfile << std::endl;

                    // printf ("\n     dis: ");
                    // for (int j = 0; j < k; j++) {
                    //     printf ("%7g ", dis[j + i * k]);
                    // }
                    // printf ("\n");
                }
                outfile.close();
            }
        }

        printf ("note that the nearest neighbor is not at "
                "distance 0 due to quantization errors\n");
    }
    logfile.close();

    delete index;

    return 0;
}
