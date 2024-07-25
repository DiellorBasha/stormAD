#!/bin/bash

# Load MATLAB module
module load matlab/2023b.2

# Load FreeSurfer module
module load StdEnv/2020
module load freesurfer/5.3.0

# When using freesurfer, the 2020 StdEnv module must be loaded first

# Load Python module
module load StdEnv/2023
module load python/3.12.4

# Add any additional commands or scripts here
virtualenv jupyter1
source jupyter1/bin/activate
# Your code goes here
pip install --no-index --upgrade pip
pip install --no-index pandas scikit_learn matplotlib seaborn