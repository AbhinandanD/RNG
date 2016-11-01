# Response Network Generator (RNG)

# INTRODUCTION

RNG can identify highly active & repressed paths and also highly influential nodes from your transcriptome data and protein-protein interaction network. Useful for gaining mechanistic insights, identifying influential paths and hubs, for target discovery and for biomarker identification.

# MINIMUM REQUIREMENTS
* Linux system with minimum 8GB of RAM and 10GB of storage space
* Python (v-2.7) & Python dependencies: networkx, zen, numpy, cython
* Git, for installing this tool and python dependencies.
* Perl (v>5)

# INSTALLATION
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

Then, to ensure complete working of the pipeline run either of the following commands:

  bash arng.sh -d disease -c control -n net_1000.txt -p 1 -f 2
                        OR                    
  bash rrng.sh -d disease -c control -n net_1000.txt -p 1 -f 2


# HELP PAGE
Get detailed help page by typing:

 # Script used for calculating active network
 
 bash arng.sh -h 

(or)

 # Script used for calculating repressed network
 
 bash rrng.sh -h
 
 
