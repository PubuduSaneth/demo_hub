# Collection of scripts used in a wide range of research projects

### Description of each script
#### 1. TCGA.level3_segment_analysis.ipynb
* Copy Number estimation and quality control of TCGA level 3 CNV data

#### 2. HB_output_analysis_amps.ipynb
* Read Genomic HyperBrowser output file
* The Genomic HyperBrowser can be used to identify genomic regions containing CNVs that are closer to chromatin domains (e.g. TADs) more than expected by chance.
* This script can read the output of the Genomic HyperBrowser

#### 3. MonteCarlo_based-hotspot_validation.ipynb
* Monte Carlo simulation based permutation test to compare gene expression profiles (log2 fold change from DeSeq2) of three datasets
* Perform KS test (Kolmogorov-Smirnov) using permutation test

#### 4. KMeans_clustering_TSNE_Viz.ipynb
* Cluster genomic regions based on somatic CNV counts
* Visualise clusters using t-SNE

#### 5. runCBS.R
* Run Circular Binary Segmentation (CBS) to segment the source file
* This script was used to run CBS and merge genome-wide 50kb genomic regions into consecutive segments with similar log2 ratios of somatic / germline CNVs
* This is an intermediate step implemented in the  KMeans_clustering_TSNE_Viz.ipynb

#### 6. 00_GAIA_script.R
 * Identify recurrent somatic CNV regions using GAIA R package

#### 7. Dockerfile
* Builds an docker image containing R packages - HMMcopy and GenomeInfoDb

#### 8. Generic python modules (scripts) that can be imported into a given python script
* ecdf.py: Compute ECDF for a one-dimensional array of measurements
* ffind.py: Find files in a given folder using a pattern
* fgenes.py: Find
    * genes in given coordinates,
    * coordinates of given genes or
    * annotate intervals with cytoband notation
