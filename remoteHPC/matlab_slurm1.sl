#!/bin/bash -l
#SBATCH --job-name=matlab_test
#SBATCH --account=def-someprof # adjust this to match the accounting group you are using to submit jobs
#SBATCH --time=0-03:00         # adjust this to match the walltime of your job
#SBATCH --nodes=1      
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1      # adjust this if you are using parallel commands
#SBATCH --mem=4000             # adjust this according to the memory requirement per node you need
#SBATCH --mail-user=you@youruniversity.ca # adjust this to match your email address
#SBATCH --mail-type=ALL

# Choose a version of MATLAB by loading a module:
module load matlab/2023b.2
# Remove -singleCompThread below if you are using parallel commands:
matlab -singleCompThread -batch "cosplot"

#Do not use the -singleCompThread option if you request more than one core with --cpus-per-task. 
#You should also ensure that the size of your MATLAB parpool matches the number of cores you are requesting.

# To compile the cosplot.m example given above, you would use the command

[name@yourserver ~]$ mcc -m -R -nodisplay cosplot.m
# This will produce a binary named cosplot, as well as a wrapper script. 
# To run the binary on our servers, you will only need the binary. 
# The wrapper script named run_cosplot.sh will not work as is on our servers because MATLAB assumes 
# that some libraries can be found in specific locations. 
# Instead, we provide a different wrapper script called run_mcr_binary.sh which sets the correct paths.

#On one of our servers, load an MCR module corresponding to the MATLAB version you used to build the executable:
[name@server ~]$ module load mcr/R2018a

# Run the following command:
[name@server ~]$ setrpaths.sh --path cosplot

# then, in your submission script (not on the login nodes), use your binary as so: 
run_mcr_binary.sh cosplot