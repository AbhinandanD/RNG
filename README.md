# Response Network Generator (RNG)

# Introduction

RNG can identify highly active & repressed paths and also highly influential nodes from your transcriptome data and protein-protein interaction network. Useful for gaining mechanistic insights, identifying influential paths and hubs, for target discovery and for biomarker identification.

# Minimum requirements
* Linux system with minimum 8GB of RAM and 10GB of storage space
* Python (v-2.7) & Python dependencies: networkx, zen, numpy, cython
* Git, for installing this tool and python dependencies.
* Perl (v>5)

# Installation
Git clone the library

# Example installation

 # Installing dependencies
  
  sudo apt-get update  
  sudo apt-get install git  
  sudo apt-get install python-pip  
  git clone https://github.com/networkdynamics/zenlib.git  
  virtualenv --distribute zenlibenv  
  sudo pip install cython  
  sudo pip install numpy  
  sudo pip install networkx  
  cd zenlib/src/  
  sudo python setup.py install  
  
 # Installing the pipeline
 
  cd  
  git clone https://github.com/AbhinandanD/RNG.git  
  cd RNG.git/

# Test run

Then, to ensure complete working of the pipeline run either of the following commands in the RNG/ directory:

  bash arng.sh -d disease -c control -n net_1000.txt -p 1 -f 2

  OR
  
  bash rrng.sh -d disease -c control -n net_1000.txt -p 1 -f 2


# Help Page

Run The pipeline as :

bash arng.sh -d condition_si(file) -c control_si(file) -n network(file) -p percentile_cut-off(value) -f upper_fold_change_cut-off(value)

OR

bash rrng.sh -d condition_si(file) -c control_si(file) -n network(file) -p percentile_cut-off(value) -f upper_fold_change_cut-off(value)

PARAMETERS

 * -d -> Tab delimited file having the normalised signal intensity for genes in the condition of interest given as GENE'\t'Normalised_signal_instensity. 

 * -c -> Tab delimited file having the normalised signal intensity for genes in the control condition given as GENE'\t'Normalised_signal_instensity.

 * -n -> Tab delimited network file given as: NODE_A'\t'NODE_B

 * -f ->  Fold change cut-off. Not log normalised. Example : when -f is 2, Response network will be calculated based on '2' fold up or down in the active response network generator (arng.sh) or the repressed response network generator (rrng.sh) respectively.  

 * -p -> Top percent cut-off. Example: when -p is 1, all paths in the 99th percentile (top 1 percent) will be used for response network identification. Values can range from 0.01 to 99.9.

NOTE: In files -d and -c, the expression values should be normalised signal intensities or counts, they should not be log transformed. All files supplied to the script should be in the RNG/ directory.

# Help page from command line

bash arng.sh -h

(or)

bash rrng.sh -h

# Output

Based on the input parameters (d,c,f & p) an output folder will be created with results. Example, output_arng_d_c_f_p/ for active response network and output_rrng_d_c_f_p/ for repressed response network. 

The pipeline creates the following files, based on the input parameters ('d'-disease, 'c'-control, 'f'-fold change & 'p'-percent cut-off):

* ew_c & ew_d : Edge weight of conditions 'c' & 'd' used to compute shortest paths.
* fc_d : Fold change calculated as condition 'd'/'c'. (For active response network)
* fc_c : Fold change calculated as condition 'c'/'d'. (For repressed response network)
* imp_deg_d : This file contains a list of genes that meet the following criteria:
 * 'f' fold upregulated/downregulated in condition 'd' for active/repressed response network respectively.
 * Participate in the paths unique to top 'p' % of the 'd' network.
* imp_uniq_ppd : Paths that occur in the top 'p' % of 'd' condition and are not taken in 'c' condition.
* sorted_shpaths_c & sorted_shpaths_d : Shortest paths of condition 'c' & 'd', sorted based on normalised path cost.
* topnet_d : Breakdown network of imp_uniq_ppd (Paths that occur in the top 'p' % of 'd' condition and are not taken in 'c' condition)
* up_deg_d : All upper differentially expressed genes based on 'f' fold change as specified by the user. (For active response network)
* down_deg_d : All lower differentially expressed genes based on 'f' fold change as specified by the user. (For repressed response network)
* log.txt : Log file for geeks, listing all steps performed by the pipeline and the time taken.
* READ_ME.txt: Description of all output files from the pipeline
