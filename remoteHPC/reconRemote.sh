#!/bin/bash
#SBATCH --account=def-baillet
#SBATCH --job-name=freesurfer
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=2:00:00

# Load the necessary modules
module load freesurfer
export SUBJECTS_DIR=~/projects/def-baillet/dbasha/PAD7/subjects
source $EBROOTFREESURFER/FreeSurferEnv.sh
# Set the input and output directories

# Run FreeSurfer
recon-all -s sub-MTL0002 -i /project/def-jpoirier/PREVENT-AD/data_release_7.0/mri/wave1/sub-MTL0002/ses-FU48A/anat/sub-MTL0002_ses-FU48A_run-01_T1w.nii.gz -i /project/def-jpoirier/PREVENT-AD/data_release_7.0/mri/wave1/sub-MTL0002/ses-FU48A/anat/sub-MTL0002_ses-FU48A_run-02_T1w.nii.gz -FLAIR /project/def-jpoirier/PREVENT-AD/data_release_7.0/mri/wave1/sub-MTL0002/ses-FU48A/anat/sub-MTL0002_ses-FU48A_FLAIR.nii.gz -FLAIRpial -all

# Additional FreeSurfer commands can be added here
