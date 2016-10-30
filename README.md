# Shp_pipeline

Testing for Shortest path pipeline

What follows will be the official README

# INTRODUCTION

shp_pipeline(insert new name for the pipeline) can identify highly active & repressed paths and also highly influential nodes from your transcriptome data and protein-protein interaction network. Useful for gaining mechanistic insights, identifying influential paths and hubs, for target discovery and for biomarker identification.

# MINIMUM REQUIREMENTS
* Linux system with minimum 8GB of RAM and 10GB of storage space
* Python (v-2.7) & Python dependencies: networkx, zen, numpy, cython
* Git, for installing this tool and python dependencies.
* Perl (v>5)

# INSTALLATION
Git clone the library

# Example INSTALLATION

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
  git clone https://github.com/AbhinandanD/shp_pipeline.git
  cd shp_pipeline.git/

# HELP PAGE
Get detailed help page by typing:

bash shpaths_analysis_pipeline_s1.sh -h (Active Network Calculator)

(or)

bash shpaths_analysis_pipeline_s2.sh -h (Repressed Network Calculator)
