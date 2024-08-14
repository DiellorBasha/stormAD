#!/usr/bin/env python3

import argparse
import os
from glob import glob
from subprocess import Popen, PIPE
from warnings import warn

def run(command, env=None, ignore_errors=False):
    """Run a shell command."""
    if env is None:
        env = {}
    merged_env = os.environ.copy()
    merged_env.update(env)
    merged_env.pop('DEBUG', None)  # Prevent large logs from FreeSurfer

    process = Popen(command, stdout=PIPE, stderr=subprocess.STDOUT, shell=True, env=merged_env)
    while True:
        line = process.stdout.readline()
        line = str(line, 'utf-8').strip()
        if line:
            print(line)
        if not line and process.poll() is not None:
            break
    if process.returncode != 0 and not ignore_errors:
        raise Exception(f"Command failed with return code {process.returncode}")

# Parse command-line arguments
parser = argparse.ArgumentParser(description='PETSurfer pipeline for processing PET data.')
parser.add_argument('bids_dir', help='Input dataset directory formatted according to the BIDS standard.')
parser.add_argument('output_dir', help='Output directory for storing processed files.')
parser.add_argument('analysis_level', help='Level of analysis: participant, group1, group2.', choices=['participant', 'group1', 'group2'])
parser.add_argument('--participant_label', nargs='+', help='Participant labels to analyze.')
parser.add_argument('--session_label', nargs='+', help='Session labels to analyze.')
parser.add_argument('--tracer', required=True, help='Tracer used in the PET dataset.')
parser.add_argument('--pet_dir', required=True, help='Directory with the PET dataset formatted according to BIDS.')
parser.add_argument('--license_file', type=str, default='/license.txt', help='Path to the FreeSurfer license key file.')
parser.add_argument('--n_cpus', type=int, default=1, help='Number of CPUs to use.')
args = parser.parse_args()

# Validate FreeSurfer license
if not os.path.exists(args.license_file):
    raise FileNotFoundError("Provided license file does not exist")

# Check FreeSurfer version
freesurfer_version = 7 if 'x86_64-7.' in open(os.path.join(os.environ['FREESURFER_HOME'], 'build-stamp.txt')).read() else 6
if freesurfer_version == 6:
    warn("Using FreeSurfer version 6. Consider upgrading to FreeSurfer 7.")

def find_pet_files(pet_directory, subject_label=None, session_label=None, tracer=None):
    """Locate PET NIfTI files for given subjects, sessions, and tracer."""
    pet_files = {}
    subjects = subject_label or [os.path.basename(s).split('-')[-1] for s in glob(os.path.join(pet_directory, "sub-*"))]

    for subject in subjects:
        subject_pet_files = {}
        sessions = session_label or [os.path.basename(s).split('-')[-1] for s in glob(os.path.join(pet_directory, f"sub-{subject}", "ses-*"))]

        for session in sessions:
            pattern = os.path.join(pet_directory, f"sub-{subject}", f"ses-{session}", "pet", f"sub-{subject}_ses-{session}_trc-{tracer}_pet.nii.gz")
            matched_files = glob(pattern)
            if matched_files:
                subject_pet_files[session] = matched_files

        if subject_pet_files:
            pet_files[subject] = subject_pet_files

    return pet_files

# Find and print PET files
pet_files = find_pet_files(args.pet_dir, args.participant_label, args.session_label, args.tracer)
if pet_files:
    print("Found PET files:")
    for subject, sessions in pet_files.items():
        for session, files in sessions.items():
            print(f"Subject: {subject}, Session: {session}, Files: {files}")
else:
    print("No PET files found.")
