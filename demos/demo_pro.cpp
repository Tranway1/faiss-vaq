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
#include <faiss/index_io.h>
#include <faiss/index_factory.h>
#include <faiss/VectorTransform.h>
#include <faiss/IndexPreTransform.h>
#include <faiss/utils/distances.h>

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
        }
    }
}

std::vector<std::vector<int>> get_belongs_cluster(const float * X, const float * C, int Xrow, int Crow, int d) {
    std::vector<std::vector<int>> members(Crow);
    for (int i=0; i<Crow; i++) {
        members[i].reserve(Xrow / Crow);
    }

    for (size_t rowIdx=0; rowIdx<Xrow; rowIdx++) {
        size_t min_idx = -1;
        float min_dist = std::numeric_limits<float>::max();
        for (size_t centIdx=0; centIdx<Crow; centIdx++) {
            float dist = faiss::fvec_L2sqr(X + (size_t)(rowIdx * d), C + centIdx * d, d);
            if (dist < min_dist) {
                min_dist = dist;
                min_idx = centIdx;
            }
        }
        members[min_idx].push_back(rowIdx);
    }
    
    return members;
};

std::vector<std::vector<int>> get_belongs_bin_cluster(const float * X, const float * C, int Xrow, int d) {
    std::vector<std::vector<int>> members(2);
    members[0].reserve(Xrow / 2);
    members[1].reserve(Xrow / 2);

    for (size_t rowIdx=0; rowIdx<Xrow; rowIdx++) {
        int min_idx = -1;
        float leftdist = faiss::fvec_L2sqr(X + (size_t)(rowIdx * d), C, d);
        float rightdist = faiss::fvec_L2sqr(X + (size_t)(rowIdx * d), C + d, d);
        if (leftdist <= rightdist) {
            members[0].push_back(rowIdx);
        } else {
            members[1].push_back(rowIdx);
        }
    }
    
    return members;
};

void slice_segment(const float * src, float * target, const size_t sz, const size_t d_in, const size_t d_out) {
    for (size_t vidx=0; vidx<sz; vidx++) {
        std::copy(src + (vidx * d_in), 
            src + (vidx * d_in + d_out),
            target + (vidx * d_out));
    }
}

void hierarchical_bin_segm(const float * X, int curr_rows, int d, int subs_len, int depth, const int maxdepth, float * ret_centroids, const int hard_limit) {
    // std::cout << "depth " << depth << std::endl;
    if (depth == maxdepth) {
        std::cout << "." << std::flush;
        float err = faiss::kmeans_clustering(d, curr_rows, 2, X, ret_centroids);
        return;
    } else {
        const int curr_dims_len = depth * subs_len;
        std::vector<float> curr_centroids(2 * curr_dims_len);
        std::vector<float> X_slice(curr_rows * curr_dims_len);
        slice_segment(X, X_slice.data(), curr_rows, d, curr_dims_len);
        float err = faiss::kmeans_clustering(curr_dims_len, curr_rows, 2, X_slice.data(), curr_centroids.data());
        // std::cout << "cluster: ";
        // for (int i=0; i<2; i++) {
        //     for (int j=0; j<curr_dims_len; j++) {
        //         std::cout << curr_centroids[i * curr_dims_len + j] << ", ";
        //     }
        //     std::cout << std::endl;
        // }

        std::vector<std::vector<int>> members_centroids = get_belongs_bin_cluster(
            X_slice.data(), curr_centroids.data(), 
            curr_rows, curr_dims_len);
        size_t sizeleft = members_centroids[0].size(),
               sizeright = members_centroids[1].size();
        // std::cout << "curr_rows = " << curr_rows << std::endl;
        // std::cout << "sizeleft = " << sizeleft << std::endl;
        // std::cout << "sizeright = " << sizeright << std::endl;
        
        const size_t tempK = 1 << (maxdepth - (depth-1));
        if (sizeleft < tempK/2 || sizeright < tempK/2 || (sizeleft+sizeright) <= (hard_limit * tempK)) {
        // if (sizeleft < tempK/2 || sizeright < tempK/2 || sizeleft <= hard_limit || sizeright <= hard_limit) {
        // if (sizeleft < tempK/2 || sizeright < tempK/2) {
            // cut the recursive calls
            // std::vector<float> cutCentroids(tempK * d);
            if (sizeleft+sizeright <= (hard_limit * tempK)) {
                // std::cout << "tempK: " << tempK << std::endl;
                std::cout << "hard_limit * tempK = " << hard_limit * tempK << "; sizeright+sizeleft = " << (sizeleft + sizeright) << ", depth " << depth << std::endl;
            }
            float err = faiss::kmeans_clustering(d, curr_rows, tempK, X, ret_centroids);
            // std::cout << "cut recursive centroids" << std::endl;
            // for (int i=0; i<tempK; i++) {
            //     for (int j=0; j<d; j++) {
            //         std::cout << cutCentroids[i * d + j] << ", ";
            //     }
            //     std::cout << std::endl;
            // }
            // std::copy(cutCentroids.data(), cutCentroids.data() + tempK * d, ret_centroids);
            std::cout << "cut recursive call" << std::endl;
            if (sizeleft < tempK/2) {
                std::cout << "sizeleft = " << sizeleft << ", depth " << depth << std::endl;
            }
            if (sizeright < tempK/2) {
                std::cout << "sizeright = " << sizeright << ", depth " << depth << std::endl;
            }
            if (sizeleft <= hard_limit) {
                std::cout << "hard_limit sizeleft = " << sizeleft << ", depth " << depth << std::endl;
            }
            if (sizeright <= hard_limit) {
                std::cout << "hard_limit sizeright = " << sizeright << ", depth " << depth << std::endl;
            }
            return;
        }

        {   //left
            std::vector<float> tempXTrainLeft(sizeleft * d);
            int ctLeft;
            for (const int left_idx: members_centroids[0]) {
                std::copy(X + left_idx * d, X + (left_idx * d + d), 
                    tempXTrainLeft.data() + ctLeft * d);
                ctLeft += 1;
            }

            auto left_centroids_loc = 0;
            hierarchical_bin_segm(tempXTrainLeft.data(), sizeleft,
                d, subs_len, depth + 1, maxdepth, ret_centroids + left_centroids_loc, hard_limit);
        }
        
        {   //right
            std::vector<float> tempXTrainRight(sizeright * d);
            int ctRight;
            for (const int right_idx: members_centroids[1]) {
                std::copy(X + (size_t)right_idx * d, X + ((size_t)right_idx * d + d), 
                    tempXTrainRight.data() + ctRight * d);
                ctRight += 1;
            }

            size_t right_centroids_loc = (tempK / 2) * d;
            hierarchical_bin_segm(tempXTrainRight.data(), sizeright,
                d, subs_len, depth + 1, maxdepth, ret_centroids + right_centroids_loc, hard_limit);
        }
    }

};

struct Args {
  std::string datasetFilepath = "";
  std::string queriesFilepath = "";
  std::string indexString = "";
  std::string resultsFilepath = "";
  std::string logFilepath = "";
  int datasetSize = 0;
//   int refine = 0;
  std::vector<int> refines;
  std::string refinestring = "";
  int queriesSize = 0;
  int N = 1;  // dimension
  std::string fileFormatOri = "fvecs";
  int K = 100;
  int hnswEfSearch = 16;
  int hnswEfConstruction = 20;
  std::vector<int> proClusters;
  std::string proClusterString = "4";
  std::vector<float> visits;
  std::string visitstring = "";
  std::vector<size_t> nvisits;
  std::string nvisit_string = "";
  bool isOPQ = false;
  int OPQSegment = 32;
  int budget = 256;
} args;

int main (int argc, char **argv)
{
    omp_set_dynamic(0);
    omp_set_num_threads(1);
    double t0 = elapsed();

    while (true) {
        static struct option long_options[] = {
            {"dataset", required_argument, 0, 'd'},
            {"queries", required_argument, 0, 'q'},
            {"results", required_argument, 0, 'r'},
            {"log", required_argument, 0, 'l'},
            {"index-string", required_argument, 0, 'v'},
            {"timeseries-size", required_argument, 0, 't'},
            {"dataset-size", required_argument, 0, 'a'},
            {"queries-size", required_argument, 0, 'u'},
            {"file-format-ori", required_argument, 0, 'z'},
            {"refine", required_argument, 0, 'e'},
            {"k", required_argument, 0, 'k'},
            {"ef-search", required_argument, 0, 'f'},
            {"ef-construction", required_argument, 0, 'c'},
            {"pro-cluster", required_argument, 0, 'b'},
            {"visit", required_argument, 0, 'g'},
            {"nvisit", required_argument, 0, 'm'},
            {"is-opq", required_argument, 0, 'h'},
            {"opq-segment", required_argument, 0, 'i'},
            {"budget", required_argument, 0, 'j'},
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
            case 'l': args.logFilepath = optarg; break;
            case 'v': args.indexString = optarg; break;
            case 't': args.N = std::atoi(optarg); break;
            case 'a': args.datasetSize = std::atoi(optarg); break;
            case 'u': args.queriesSize = std::atoi(optarg); break;
            case 'z': args.fileFormatOri = optarg; break;
            case 'e': args.refinestring = optarg; break;
            case 'k': args.K = std::atoi(optarg); break;
            case 'f': args.hnswEfSearch = std::atoi(optarg); break;
            case 'c': args.hnswEfConstruction = std::atoi(optarg); break;
            case 'b': args.proClusterString = optarg; break;
            case 'g': args.visitstring = optarg; break;
            case 'm': args.nvisit_string = optarg; break;
            case 'h': args.isOPQ = std::atoi(optarg); break;
            case 'i': args.OPQSegment = std::atoi(optarg); break;
            case 'j': args.budget = std::atoi(optarg); break;
            case '?':
                printf( 
                "Usage:\n\
                \t--dataset XX \t\t\tThe path to the dataset file\n\
                \t--queries XX \t\t\tThe path to the queries file\n\
                \t--results XX \t\t\tThe path to the results filepath\n\
                \t--log XX \t\t\tThe path to the log file\n\
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

    if (args.visitstring != "") {
        std::stringstream ss(args.visitstring);

        while (ss.good()) {
            std::string substr;
            getline( ss, substr, ',' );
            args.visits.push_back(std::stof(substr));
        }
    } else {
        args.visits.push_back(1);
    }
    
    if (args.nvisit_string != "") {
        std::stringstream ss(args.nvisit_string);

        while (ss.good()) {
            std::string substr;
            getline( ss, substr, ',' );
            args.nvisits.push_back(std::stoi(substr));
        }
    } else {
        args.nvisits.push_back(1);
    }

    if (args.proClusterString != "") {
        std::stringstream ss(args.proClusterString);

        while (ss.good()) {
            std::string substr;
            getline( ss, substr, ',');
            args.proClusters.push_back(std::stoi(substr));
        }
    }

    bool need_pad = false;
    if ((args.N % args.OPQSegment) > 0) {
        need_pad = true;
    }

    // dimension of the vectors to index
    int d = args.N;
    if (need_pad) {
        d = ((args.N / args.OPQSegment) + 1) * args.OPQSegment;
    }

    // size of the database we plan to index
    size_t nb = args.datasetSize;

    printf("Args:\n");
    printf("\tdimension = %d\n", args.N);
    if (need_pad) {
        printf("\tdimension after pad = %d\n", d);
    }
    printf("\tdataset size = %d\n", args.datasetSize);
    printf("\tqueries size = %d\n", args.queriesSize);
    printf("\tdataset filepath = %s\n", args.datasetFilepath.c_str());
    printf("\tqueries filepath = %s\n", args.queriesFilepath.c_str());
    printf("\tresults filepath = %s\n", args.resultsFilepath.c_str());
    printf("\tlog filepath = %s\n", args.logFilepath.c_str());
    printf("\tindex-string: %s\n", args.indexString.c_str());
    printf("\tpro-cluster: %s\n", args.proClusterString.c_str());
    printf("\tbudget: %d\n", args.budget);
    printf("\tvisit: %s\n", args.visitstring.c_str());
    if (args.isOPQ)  {
        printf("\tOPQ segment: %d\n", args.OPQSegment);
    }
    printf("\tK: %d\n", args.K);
    if (args.refinestring != "") {
        printf("\tRefine: %s\n", args.refinestring.c_str());
    }

    std::vector<float> database(nb * args.N);
    read_data_bin(args.datasetFilepath, database, args.N, nb);
    if (need_pad) {
        std::vector<float> temp_database = database;
        database.resize(nb * d);
        faiss::RemapDimensionsTransform remap(args.N, d, false);
        remap.apply_noalloc(nb, temp_database.data(), database.data());
    }
    float * database_ptr = database.data();
    
    double tot_training_time = 0;

    faiss::OPQMatrix opq(d, args.OPQSegment);
    if (args.isOPQ) {
        double start_time_opq = elapsed(), finish_time_opq;
        // train opq
        opq.train(nb, database.data());
        opq.verbose = false;
        
        const size_t bs = 10000000;
        if (nb > bs) {
            std::vector<float> temp_slice(bs * d);
            int batchNum = nb / bs;
            if (nb % bs > 0) {
                batchNum += 1;
            }

            for (size_t b=0; b<batchNum; b++) {
                size_t currBatchRows = bs;
                if ((b == batchNum-1) && (nb % bs > 0)) {
                    currBatchRows = nb % bs;
                }
                const size_t base_idx = b * bs;
                opq.apply_noalloc(currBatchRows, database.data() + (base_idx * d), temp_slice.data());
                std::copy(temp_slice.data(), temp_slice.data() + (currBatchRows * d), database.data() + (base_idx * d));
            }
        } else {
            database_ptr = opq.apply(nb, database.data());
            database.resize(0);
        }

        finish_time_opq = elapsed();
        tot_training_time += (finish_time_opq-start_time_opq);
        std::cout << "OPQ time: " << finish_time_opq-start_time_opq << std::endl;
    }

    int counter = 0;
    for (const int proCluster: args.proClusters) {
        double tot_training_time_loop = tot_training_time, tot_encoding_time_loop = 0;
        std::cout << "creating initial cluster " << proCluster << std::endl;
        double start_time_pro = elapsed(), finish_time_pro;
        // create pro cluster
        size_t pro_cluster_num = proCluster;
        std::vector<float> pro_centroids(pro_cluster_num * d, 0);
        std::vector<std::vector<int>> pro_cluster_members;
        if (false) {
            pro_cluster_members.resize(pro_cluster_num);
            float err = faiss::kmeans_clustering(d, nb, pro_cluster_num,
                database_ptr, pro_centroids.data());
            // std::cout << "kmeans final quantization error: " << err <<  std::endl;

            std::cout << "filling cluster" << std::endl;
            // filling cluster
            for (size_t i=0; i<pro_cluster_num; i++) {
                pro_cluster_members[i].reserve(nb / pro_cluster_num);
            }

            constexpr int threadnum = 1;
            #pragma omp parallel num_threads(threadnum)
            {
            std::vector<std::vector<int>> privateClustersMember(pro_cluster_num);
            for (int i=0; i<pro_cluster_num; i++) {
                privateClustersMember[i].reserve(nb / (pro_cluster_num*threadnum));
            }

            #pragma omp for nowait schedule(static)
            for (int i=0; i<nb; i++) {
                float * x = database_ptr + (i * d);

                float closestDist = std::numeric_limits<float>::max();
                int closestIdx = -1;
                std::vector<float> dists(pro_cluster_num);
                faiss::fvec_L2sqr_ny(dists.data(), x, pro_centroids.data(), d, pro_cluster_num);
                for (int c=0; c<pro_cluster_num; c++) {
                float dist = std::sqrt(dists[c]);
                if (dist < closestDist) {
                    closestIdx = c;
                    closestDist = dist;
                }
                }
                privateClustersMember[closestIdx].push_back(i);
            }

            const int num_threads = omp_get_num_threads();
            #pragma omp for schedule(static) ordered
            for (int i=0; i<num_threads; i++) {
                #pragma omp ordered
                {
                for (int c=0; c<pro_cluster_num; c++) {
                    pro_cluster_members[c].insert(
                    pro_cluster_members[c].end(),
                    privateClustersMember[c].begin(),
                    privateClustersMember[c].end()
                    );
                }
                }
            }
            }
        } else {
            int power_cluster = 1;
            int num = proCluster;
            while(num > 2) {
                num /= 2;
                power_cluster += 1;
            }
            std::cout << "power_cluster: " << power_cluster << std::endl;
            int start_cluster = 2;
            if (power_cluster > args.OPQSegment) {
                start_cluster = (int)std::pow(2, power_cluster-args.OPQSegment + 1);
            }
            const int subs_len = d / args.OPQSegment;
            const int highest_segm = (int)std::min(power_cluster, args.OPQSegment);
            int highest_dim = highest_segm * subs_len;

            // std::cout << "ori database: " << std::endl;
            // for (int i=0; i<1; i++) {
            //     for (int j=0; j<highest_dim; j++) {
            //         std::cout << *(database_ptr + (i * d + j)) << ", ";
            //     }
            //     std::cout << std::endl;
            // }

            highest_dim = d;

            faiss::PCAMatrix pca(d, highest_dim);
            // size_t pca_database_size = std::min((size_t)(256 * proCluster), nb);
            size_t pca_database_size = nb;
            std::vector<float> pca_database;
            {
                size_t pca_database_sample_size = nb;
                const float * pca_database_sample_ptr = faiss::fvecs_maybe_subsample(
                    d, &pca_database_sample_size, 1000 * d, database_ptr);
                faiss::ScopeDeleter<float> del_pca_db (pca_database_sample_ptr != database_ptr ? pca_database_sample_ptr : nullptr);
                
                pca.train(pca_database_sample_size, pca_database_sample_ptr);
                std::cout << "PCA train done" << std::endl;
            }
            {
                size_t pca_database_temp_size = nb;
                const float * pca_database_temp_ptr = faiss::fvecs_maybe_subsample(
                    d, &pca_database_temp_size, pca_database_size, database_ptr);
                faiss::ScopeDeleter<float> del_pca_temp_db(pca_database_temp_ptr != database_ptr ? pca_database_temp_ptr : nullptr);
                
                pca_database_size = pca_database_temp_size;
                pca_database.resize(pca_database_size * highest_dim);
                
                pca.apply_noalloc(pca_database_size, pca_database_temp_ptr, pca_database.data());
                std::cout << "PCA apply done" << std::endl;
            }
            // std::cout << "pca database: " << std::endl;
            // for (int i=0; i<1; i++) {
            //     for (int j=0; j<highest_dim; j++) {
            //         std::cout << *(pca_database[i * highest_dim + j]) << ", ";
            //     }
            //     std::cout << std::endl;
            // }
            
            std::vector<float> pca_pro_centroids(pro_cluster_num * highest_dim, 999999);
            std::cout << "pro_cluster_num: " << pro_cluster_num << std::endl;
            std::cout << "pca_database_size: " << pca_database_size << std::endl;
            std::cout << "start_cluster: " << start_cluster << std::endl;
            std::cout << "subs_len: " << subs_len << std::endl;
            std::cout << "highest_segm: " << highest_segm << std::endl;
            std::cout << "highest_dim: " << highest_dim << std::endl;

            if (start_cluster > 2) {
                std::vector<float> start_centroids(start_cluster * subs_len);

                std::vector<float> pca_first_subsdata(pca_database_size * subs_len * 1);
                for (size_t vidx=0; vidx<pca_database_size; vidx++) {
                    std::copy(pca_database.data() + (vidx * highest_dim), 
                        pca_database.data() + ((vidx * highest_dim) + subs_len), 
                        pca_first_subsdata.data() + (vidx * subs_len));
                }

                float err = faiss::kmeans_clustering(subs_len * 1, pca_database_size, start_cluster, 
                    pca_first_subsdata.data(), start_centroids.data());
                std::cout << "first cluster done" << std::endl;

                std::vector<std::vector<int>> members_centroids = get_belongs_cluster(
                    pca_first_subsdata.data(), start_centroids.data(), pca_database_size, start_cluster, subs_len);
                std::cout << "get belong done" << std::endl;
                for (int c=0; c<start_cluster; c++) {
                    int curr_cluster_size = members_centroids[c].size();
                    std::vector<float> database_slice(curr_cluster_size * highest_dim);
                    for (size_t vidx=0; vidx<curr_cluster_size; vidx++) {
                        std::copy(pca_database.data() + ((size_t)members_centroids[c][vidx] * highest_dim), 
                            pca_database.data() + ((size_t)members_centroids[c][vidx] * highest_dim + highest_dim),
                            database_slice.data() + vidx * highest_dim);
                    }

                    size_t pro_centroids_loc = (pro_cluster_num / start_cluster) * c;
                    hierarchical_bin_segm(database_slice.data(), curr_cluster_size, 
                        highest_dim, subs_len, 2, highest_segm, pca_pro_centroids.data() + pro_centroids_loc, pca_database_size / 256);
                }
            } else {
                omp_set_num_threads(1);
                hierarchical_bin_segm(pca_database.data(), pca_database_size, 
                    highest_dim, subs_len, 1, highest_segm, pca_pro_centroids.data(), pca_database_size / 256);
                std::cout << std::endl;
            }

            // std::cout << "centroid PCA" << std::endl;
            // for (int i=0; i<1; i++) {
            //     for (int j=0; j<highest_dim; j++) {
            //         std::cout << pca_pro_centroids[i * highest_dim + j] << ", ";
            //     }
            //     std::cout << std::endl;
            // }

            auto get_belongs_cluster_pca_l = [](const float * X, const float * C, int Xrow, int Crow, int d, const faiss::PCAMatrix &pca) -> std::vector<std::vector<int>> {
                std::vector<std::vector<int>> members(Crow);
                for (int i=0; i<Crow; i++) {
                    members[i].reserve(Xrow / Crow);
                }

                const int bs = 1000000;
                if (Xrow > bs) {
                    int batchNum = Xrow / bs;
                    if (Xrow % bs > 0) {
                        batchNum += 1;
                    }
                    std::cout << "for belong cluster" << std::endl;
                    
                    for (int b=0; b<batchNum; b++) {
                        std::cout << "." << std::flush;
                        int currBatchRows = bs;
                        if ((b == batchNum-1) && (Xrow % bs > 0)) {
                            currBatchRows = Xrow % bs;
                        }
                        const size_t base_idx = b*bs;
                        const float *x_pca = pca.apply(currBatchRows, X + (base_idx * d));
                        faiss::ScopeDeleter<float> del_x_pca(x_pca);

                        omp_set_dynamic(0);
                        // constexpr int thread_num = 15;

                        std::vector<int> members_flat(currBatchRows);
                        // #pragma omp parallel for num_threads(thread_num)
                        for (int rowIdx=0; rowIdx<currBatchRows; rowIdx++) {
                            int min_idx = -1;
                            float min_dist = std::numeric_limits<float>::max();
                            std::vector<float> dists(Crow);
                            faiss::fvec_L2sqr_ny(dists.data(), x_pca + (rowIdx * d), C, d, Crow);
                            for (int centIdx=0; centIdx<Crow; centIdx++) {
                                if (dists[centIdx] < min_dist) {
                                    min_dist = dists[centIdx];
                                    min_idx = centIdx;
                                }
                            }
                            if (min_idx == -1) {
                                for (int centIdx=0; centIdx<Crow; centIdx++) {
                                    exit(0);
                                }
                            }
                            members_flat[rowIdx] = min_idx;
                        }

                        for (int rowIdx=0; rowIdx<currBatchRows; rowIdx++) {
                            members[members_flat[rowIdx]].push_back(rowIdx + (b * bs));
                        }
                    }
                    std::cout << std::endl;
                } else {
                    const float *x_pca = pca.apply(Xrow, X);
                    faiss::ScopeDeleter<float> del_x_pca(x_pca);

                    std::vector<int> members_flat(Xrow);

                    omp_set_dynamic(0);
                    // constexpr int thread_num = 1;
                    const size_t whatXrow = Xrow;
                    // #pragma omp parallel for schedule (static,1) num_threads(thread_num)
                    for (size_t rowIdx=0; rowIdx<whatXrow; rowIdx++) {
                        int min_idx = -1;
                        float min_dist = std::numeric_limits<float>::max();
                        std::vector<float> dists(Crow);
                        faiss::fvec_L2sqr_ny(dists.data(), x_pca + (rowIdx * d), C, d, Crow);
                        for (int centIdx=0; centIdx<Crow; centIdx++) {
                            if (dists[centIdx] < min_dist) {
                                min_dist = dists[centIdx];
                                min_idx = centIdx;
                            }
                        }
                        members_flat[rowIdx] = min_idx;
                    }

                    for (int rowIdx=0; rowIdx<Xrow; rowIdx++) {
                        members[members_flat[rowIdx]].push_back(rowIdx);
                    }
                }

                return members;
            };

            {
                std::vector<std::vector<int>> members(pro_cluster_num);
                for (int i=0; i<pro_cluster_num; i++) {
                    members[i].reserve(nb / pro_cluster_num);
                }

                const int bs = 1000000;
                if (nb > bs) {
                    int batchNum = nb / bs;
                    if (nb % bs > 0) {
                        batchNum += 1;
                    }
                    std::cout << "for belong cluster" << std::endl;
                    
                    for (size_t b=0; b<batchNum; b++) {
                        std::cout << "." << std::flush;
                        int currBatchRows = bs;
                        if ((b == batchNum-1) && (nb % bs > 0)) {
                            currBatchRows = nb % bs;
                        }
                        const size_t base_idx = b*bs;
                        const float *x_pca = pca.apply(currBatchRows, database_ptr + (base_idx * highest_dim));
                        faiss::ScopeDeleter<float> del_x_pca(x_pca);

                        omp_set_dynamic(0);
                        // constexpr int thread_num = 15;

                        std::vector<int> members_flat(currBatchRows);
                        // #pragma omp parallel for shared(members_flat, x_pca) num_threads(thread_num)
                        for (size_t rowIdx=0; rowIdx < currBatchRows; rowIdx++) {
                            int min_idx = -1;
                            float min_dist = std::numeric_limits<float>::max();
                            std::vector<float> dists(pro_cluster_num);
                            faiss::fvec_L2sqr_ny(dists.data(), x_pca + (rowIdx * highest_dim), pca_pro_centroids.data(), highest_dim, pro_cluster_num);
                            for (int centIdx=0; centIdx<pro_cluster_num; centIdx++) {
                                if (dists[centIdx] < min_dist) {
                                    min_dist = dists[centIdx];
                                    min_idx = centIdx;
                                }
                            }
                            members_flat[rowIdx] = min_idx;
                        }

                        for (int rowIdx=0; rowIdx<currBatchRows; rowIdx++) {
                            members[members_flat[rowIdx]].push_back(rowIdx + base_idx);
                        }
                    }
                    std::cout << std::endl;
                } else {
                    const float *x_pca = pca.apply(nb, database_ptr);
                    faiss::ScopeDeleter<float> del_x_pca(x_pca);

                    std::vector<int> members_flat(nb);

                    // omp_set_num_threads(2);
                    // constexpr int thread_num = 2;
                    for (size_t rowIdx=0; rowIdx<nb; rowIdx++) {
                        int min_idx = -1;
                        float min_dist = std::numeric_limits<float>::max();
                        std::vector<float> dists(pro_cluster_num);
                        faiss::fvec_L2sqr_ny(dists.data(), x_pca + (rowIdx * highest_dim), pca_pro_centroids.data(), highest_dim, pro_cluster_num);
                        for (int centIdx=0; centIdx<pro_cluster_num; centIdx++) {
                            if (dists[centIdx] < min_dist) {
                                min_dist = dists[centIdx];
                                min_idx = centIdx;
                            }
                        }
                        members_flat[rowIdx] = min_idx;
                    }

                    for (int rowIdx=0; rowIdx<nb; rowIdx++) {
                        members[members_flat[rowIdx]].push_back(rowIdx);
                    }
                }

                pro_cluster_members = members;
            }

            // pro_cluster_members = get_belongs_cluster_pca_l(
            //     database_ptr, pca_pro_centroids.data(), nb, pro_cluster_num, highest_dim, pca);
            std::cout << "belongs cluster no problem" << std::endl;
            std::cout << "pro_cluster_members.size(): " << pro_cluster_members.size() << std::endl;
            for (size_t i=0; i<pro_cluster_num; i++) {
                //std::cout << "pro_cluster_members[i].size(): " << pro_cluster_members[i].size() << std::endl;
                if (pro_cluster_members[i].size() > 0) {
                    std::vector<float> one_centroid(d, 0);
                    for (const int mem: pro_cluster_members[i]) {
                        for (size_t j=0; j<d; j++) {
                            one_centroid[j] += *(database_ptr + ((size_t)mem * d + j));
                        }
                    }
                    // std::cout << "centroid " << i << ": " << std::flush;
                    for (int j=0; j<d; j++) {
                        one_centroid[j] /= pro_cluster_members[i].size();
                        // std::cout << one_centroid[j] << ", " << std::flush;
                    }
                    // std::cout << std::endl;
                    
                    std::copy(one_centroid.data(), one_centroid.data() + d, pro_centroids.data() + (i * d));
                } else {
                    std::cout << "there's cluster with 0 members" << std::endl;
                }
            }
            // exit(0);
        }

        std::cout << "initial cluster stats " << pro_cluster_num << " : " << std::endl;
        for (size_t clus_idx=0; clus_idx < pro_cluster_num; clus_idx++) {
            std::cout << pro_cluster_members[clus_idx].size() << '.';
        }
        std::cout << std::endl;

        std::vector<faiss::Index *> indexes(pro_cluster_num);
        finish_time_pro = elapsed();
        printf("Pro Training Time: %.4f s\n", finish_time_pro-start_time_pro);
        std::cout << std::flush;
        tot_training_time_loop += (finish_time_pro-start_time_pro);
        if (args.N > 10000) {
            omp_set_num_threads(12);
        }
        double tm_st = omp_get_wtime();
        // train each cluster
        double tot_training_time_loop_temp = 0;
        // #pragma omp parallel for schedule(static) shared(indexes, tot_encoding_time_loop, tot_training_time_loop_temp) reduction(+: tot_training_time_loop_temp, tot_encoding_time_loop)
        for (size_t clus_idx=0; clus_idx < pro_cluster_num; clus_idx++) {
            if (pro_cluster_members[clus_idx].size() > 0) {
                double start_time = elapsed(), finish_time;
                std::vector<float> database_slice(pro_cluster_members[clus_idx].size() * d);
                size_t database_slice_rows = pro_cluster_members[clus_idx].size();
                for (size_t vec_idx=0; vec_idx < pro_cluster_members[clus_idx].size(); vec_idx++) {
                    size_t actual_idx = pro_cluster_members[clus_idx][vec_idx];
                    std::copy(database_ptr + (actual_idx * d), 
                        database_ptr + (actual_idx * d) + d,
                        database_slice.data() + (vec_idx * d));
                }
                size_t min_members = (size_t)(std::pow(2, (args.budget / args.OPQSegment)));
                if (pro_cluster_members[clus_idx].size() < min_members) {
                    faiss::RandomGenerator rng (1234 + clus_idx);
                    database_slice.resize(min_members * d);
                    for (size_t i=pro_cluster_members[clus_idx].size(); i<min_members; i++) {
                        int randIdx = rng.rand_int(pro_cluster_members[clus_idx].size());
                        std::copy(database_slice.data() + (size_t)randIdx * d,
                            database_slice.data() + ((size_t)randIdx * d + d),
                            database_slice.data() + (i * d));
                    }
                    database_slice_rows = min_members;
                }
                // std::ofstream logfile;
                // logfile.open(args.logFilepath, std::ofstream::out | std::ofstream::app);
                { // training & encoding
                    // std::cout << clus_idx << ", " << std::flush;
                    indexes[clus_idx] = faiss::index_factory(d, args.indexString.c_str());
                    // printf ("[%.3f s] Training the index\n",
                    //         elapsed() - t0);
                    
                    // {   // sqrt formula
                    //     double avg_sample_size = (256 * std::sqrt(nb)) / pro_cluster_num;
                    //     double c = avg_sample_size / (std::sqrt((double)nb / pro_cluster_num) * min_members);
                    //     // size_t max_points = static_cast<size_t>(std::ceil(std::sqrt(database_slice_rows))); // sqrt(rows)
                    //     size_t max_points = static_cast<size_t>(std::ceil(c * std::sqrt(database_slice_rows)));
                    //     // size_t max_points = static_cast<size_t>(std::ceil(0.0883 * std::sqrt(database_slice_rows))); // 128 cluster
                    //     // size_t max_points = static_cast<size_t>(std::ceil(1 * std::ceil(std::sqrt(database_slice_rows)) / min_members)); // c * sqrt(rows)
                    //     // size_t max_points = static_cast<size_t>(std::ceil((database_slice_rows / 4.0) / min_members)); // 25% rows
                    //     faiss::IndexPQ *pqIndex = (faiss::IndexPQ *)indexes[clus_idx];
                    //     if (max_points < pqIndex->pq.cp.min_points_per_centroid) {
                    //         max_points = pqIndex->pq.cp.min_points_per_centroid;
                    //     } 
                    //     // else if (max_points > 256) {
                    //     //     max_points = 256;
                    //     // }
                    //     pqIndex->pq.cp.max_points_per_centroid = max_points;
                    // }

                    if (false){   // distribute proportinaly PQ
                        double tot_sample_size = 512 * std::sqrt(nb) / 1;
                        // double tot_sample_size = 256000;
                        size_t max_points = static_cast<size_t>(std::ceil((tot_sample_size * (double)database_slice_rows / nb) / min_members));
                        faiss::IndexPQ *pqIndex = (faiss::IndexPQ *)indexes[clus_idx];
                        if (max_points < pqIndex->pq.cp.min_points_per_centroid) {
                            pqIndex->pq.cp.max_points_per_centroid = max_points;
                            pqIndex->pq.cp.min_points_per_centroid = max_points;
                        } else {
                            pqIndex->pq.cp.max_points_per_centroid = max_points;
                        }
                        // std::cout << "min points: " << pqIndex->pq.cp.min_points_per_centroid << std::endl;
                        // pqIndex->pq.cp.min_points_per_centroid = 1;
                    } 


                    indexes[clus_idx]->train (database_slice_rows, database_slice.data());
                    finish_time = elapsed();
                    // printf("Training Time: %.4f s\n", finish_time-start_time);

                    tot_training_time_loop_temp += (finish_time-start_time);
                    // logfile << finish_time-start_time << ',';
                    
                    // printf ("[%.3f s] Adding the vectors to the index\n",
                    //         elapsed() - t0);

                    start_time = elapsed();

                    indexes[clus_idx]->add (pro_cluster_members[clus_idx].size(), database_slice.data());
                    finish_time = elapsed();
                    // printf("Encoding Time: %.4f s\n", finish_time-start_time);
                    tot_encoding_time_loop += (finish_time-start_time);
                    // logfile << finish_time-start_time << ',';
                }
            }
        }
        double tm_ed = omp_get_wtime();
        std::cout << "work took " << (tm_ed - tm_st) << std::endl;
        tot_training_time_loop += tot_training_time_loop_temp;
        // std::cout << std::endl;
        printf("Total Training Time: %.4f s\n", tot_training_time_loop);
        printf("Total Encoding Time: %.4f s\n", tot_encoding_time_loop);

        {
            
            omp_set_num_threads(1);

            std::vector<size_t> nvisit_temp;
            if (args.nvisit_string != "") {
                nvisit_temp = args.nvisits;
                std::cout << "visits: ";
                for (const size_t visit: nvisit_temp) {
                    std::cout << visit << ", ";
                }
                std::cout << std::endl;
            } else {
                nvisit_temp.reserve(args.visits.size());
                for (const float visit: args.visits) {
                    size_t max_visit = static_cast<size_t>(((float)pro_cluster_num * visit));
                    if (max_visit == 0) {
                        max_visit = 1;
                    }
                    nvisit_temp.push_back(max_visit);
                }
                std::cout << "visits: ";
                for (const float visit: args.visits) {
                    std::cout << visit << ", ";
                }
                std::cout << std::endl;
            }
            size_t ct = 0;
            for (const size_t n_visit: nvisit_temp) {

                // searching
                size_t nq = args.queriesSize;
                std::vector<float> queries(nq * args.N);
                read_data_bin(args.queriesFilepath, queries, args.N, nq);
                if (need_pad) {
                    std::vector<float> temp_queries = queries;
                    queries.resize(nq * d);
                    faiss::RemapDimensionsTransform remap(args.N, d, false);
                    remap.apply_noalloc(nq, temp_queries.data(), queries.data());
                }
                float * queries_ptr = queries.data();

                size_t nnNum = args.K;
                if (args.refines[0] != 0) {
                    nnNum = args.refines[0];
                }

                double start_time = elapsed(), finish_time;
                if (args.isOPQ) {
                    queries_ptr = opq.apply(nq, queries.data());
                }

                size_t max_cluster_visit = n_visit;

                std::vector<faiss::Index::idx_t> nns_all (nnNum * nq);
                std::vector<float>               dis_all (nnNum * nq);
                double prep_visit_time = 0;
                for (size_t q_idx=0; q_idx < nq; q_idx++) {
                    double prep_visit_time_start = elapsed();
                    std::vector<float> qToCCDist(pro_cluster_num);
                    std::vector<int> qToCCIdx(pro_cluster_num);
                    faiss::fvec_L2sqr_ny(qToCCDist.data(), queries_ptr + q_idx * d, pro_centroids.data(), d, pro_cluster_num);
                    for (int i=0; i<(int)qToCCDist.size(); i++) {
                        qToCCDist[i] = std::sqrt(qToCCDist[i]);
                        qToCCIdx[i] = i;
                    }
                    std::sort(qToCCIdx.data(), qToCCIdx.data()+qToCCIdx.size(), 
                            [&qToCCDist](int i, int j) -> bool {
                                return qToCCDist[i] < qToCCDist[j];
                        }
                    );
                    prep_visit_time += elapsed() - prep_visit_time_start;


                    for (size_t curr_clus_idx=0; curr_clus_idx < max_cluster_visit; curr_clus_idx++) {
                        size_t clus_idx = qToCCIdx[curr_clus_idx];
                        if (pro_cluster_members[clus_idx].size() > 0) {
                            std::vector<faiss::Index::idx_t> nns_temp (nnNum);
                            std::vector<float>               dis_temp (nnNum);
                            indexes[clus_idx]->search (1, queries_ptr + q_idx * d, nnNum, dis_temp.data(), nns_temp.data());
                            
                            // translate nns indexes
                            if (curr_clus_idx > 0) {
                                float * curr_dis_all = dis_all.data() + q_idx * nnNum;
                                faiss::Index::idx_t * curr_nns_all = nns_all.data() + q_idx * nnNum;
                                
                                for (int i=0; i<nnNum; i++) {
                                    if (nns_temp[i] == -1) {
                                        break;
                                    }
                                    size_t idx = nnNum - 1;
                                    float newnn_dist = dis_temp[i];

                                    if (newnn_dist < curr_dis_all[idx]) {
                                        curr_dis_all[idx] = newnn_dist;
                                        curr_nns_all[idx] = pro_cluster_members[clus_idx][nns_temp[i]];
                                    } else {
                                        break;
                                    }
                                    while (idx > 0 && curr_dis_all[idx-1] > newnn_dist) {
                                        std::swap(curr_dis_all[idx-1], curr_dis_all[idx]);
                                        std::swap(curr_nns_all[idx-1], curr_nns_all[idx]);
                                        idx--;
                                    }
                                }
                            } else {
                                for (int i=0; i<nnNum; i++) {
                                    nns_temp[i] = pro_cluster_members[clus_idx][nns_temp[i]];
                                }
                                std::copy(nns_temp.data(), nns_temp.data() + nnNum, nns_all.data() + q_idx * nnNum);
                                std::copy(dis_temp.data(), dis_temp.data() + nnNum, dis_all.data() + q_idx * nnNum);
                            }
                        } else {
                            max_cluster_visit = (max_cluster_visit+1 <= pro_cluster_num) ? (max_cluster_visit+1) : max_cluster_visit;
                        }
                    }
                }
    
                // manual refinement
                if (args.refines[0] != 0) {
                    for (size_t q_idx=0; q_idx < nq; q_idx++) {
                        std::vector<float> dis_refined(nnNum);
                        std::vector<size_t> nns_refined_loc(nnNum);
                        for (size_t v_idx=0; v_idx < nnNum; v_idx++) {
                            dis_refined[v_idx] = faiss::fvec_L2sqr(queries_ptr + q_idx * d, database_ptr + nns_all[q_idx * nnNum + v_idx] * d, d);
                            nns_refined_loc[v_idx] = v_idx;
                        }

                        std::sort(nns_refined_loc.data(), nns_refined_loc.data() + nnNum,
                            [&dis_refined](size_t i, size_t j) -> bool {
                                return dis_refined[i] < dis_refined[j];
                            }
                        );
                        // translate
                        std::vector<faiss::Index::idx_t> nns_refined_temp(nnNum);
                        std::copy(nns_all.data() + q_idx * nnNum, nns_all.data() + (q_idx * nnNum + nnNum), nns_refined_temp.data());
                        for (size_t i=0; i<nnNum; i++) {
                            nns_all[q_idx * nnNum + i] = nns_refined_temp[nns_refined_loc[i]];
                        }
                    }
                }

                finish_time = elapsed();
                printf("%.8f\n", finish_time-start_time);
                printf("Prep= %.8f , Search= %.8f\n", prep_visit_time, (finish_time-start_time)-(prep_visit_time));
                fflush(stdout);

                {   
                    std::string finalResultsFP = args.resultsFilepath;
                    // if (args.proClusters.size() > 1) {
                        finalResultsFP.append("_cluster" + std::to_string(proCluster));
                    // }
                    // if (args.visits.size() > 1) {
                        if (args.nvisit_string != "") {
                            finalResultsFP.append("_NV" + std::to_string(n_visit));
                        } else {
                            finalResultsFP.append("_V" + std::to_string(args.visits[ct]));
                        }
                    if (args.refines[0] != 0) {
                        finalResultsFP.append("_R" + std::to_string(nnNum));
                    }
                    finalResultsFP.append(".csv");
                    // }
                    std::ofstream outfile;
                    outfile.open(finalResultsFP);

                    for (int i = 0; i < nq; i++) {
                        // printf ("query %2d: ", i);
                        for (int j = 0; j < args.K; j++) {
                            // if (i == 0 && j < 10) {
                            //     std::cout << dis_all[j + i * args.K] << ", ";
                            // }
                            // printf ("%7ld ", nns[j + i * k]);
                            outfile << nns_all[j + i * nnNum];
                            if (j != args.K-1) {
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
                    // std::cout << std::endl;
                    outfile.close();
                }
                if (args.isOPQ) {
                    delete[] queries_ptr;
                }
                system("sudo clearcache.sh");
                ct++;
            }

        }

        // logfile.close();
        for (size_t i=0; i<pro_cluster_num; i++) {
            delete indexes[i];
        }
    }


    if (args.isOPQ && nb <= 10000000) {
        delete[] database_ptr;
    }
    // delete database_ptr;

    return 0;
}
