#!/usr/bin/env python3

import argparse
import os
from glob import glob
from subprocess import Popen, PIPE
from warnings import warn
import re

def run(command, env={}, ignore_errors=False):
    merged_env = os.environ
    merged_env.update(env)
    merged_env.pop('DEBUG', None)  # DEBUG env triggers large FreeSurfer logs

    process = Popen(command, stdout=PIPE, stderr=subprocess.STDOUT, shell=True, env=merged_env)
    while True:
        line = process.stdout.readline()
        line = str(line, 'utf-8')[:-1]
        print(line)
        if line == '' and process.poll() is not None:
            break
    if process.returncode != 0 and not ignore_errors:
        raise Exception("Non-zero return code: %d" % process.returncode)

# Version check and warning for FreeSurfer
with open(os.path.join(os.environ['FREESURFER_HOME'], 'build-stamp.txt'), 'r') as h:
    bs = h.read()
fsversion = 7 if 'x86_64-7.' in bs else 6
if fsversion == 6:
    warn("You are using FreeSurver version 6. FreeSurfer 7 will become the default version in 2024.")
# __version__ = open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'version')).read()

parser = argparse.ArgumentParser(description='FreeSurfer recon-all + PETSurfer processing.')
parser.add_argument('bids_dir', help='The directory with the input dataset formatted according to the BIDS standard.')
parser.add_argument('output_dir', help='The directory where the output files should be stored.')
parser.add_argument('analysis_level', help='Level of the analysis that will be performed.', choices=['participant', 'group1', 'group2'])
parser.add_argument('--participant_label', nargs="+", help='The label of the participant to analyze.')
parser.add_argument('--session_label', nargs="+", help='The label of the session to analyze.')
parser.add_argument('--tracer', help='The tracer used in the PET dataset.')
parser.add_argument('--pet_dir', help='The directory with the input PET dataset formatted according to the BIDS standard.')
parser.add_argument('--petsurfer', help='Enables the PETSurfer pipeline', choices=['true', 'false'], default='false')
parser.add_argument('--license_file', type=str, default='/license.txt', help='Path to FreeSurfer license key file.')
parser.add_argument('--n_cpus', default=1, type=int, help='Number of CPUs/cores available to use.')
args = parser.parse_args()

if args.license_file and not os.path.exists(args.license_file):
    raise Exception("Provided license file does not exist")

# if not args.skip_bids_validator:
#     run(f"bids-validator {args.bids_dir}")
# else:
#     print('Skipping bids-validator...')

subject_dirs = glob(os.path.join(args.bids_dir, "sub-*"))
pet_subject_dirs = glob(os.path.join(args.pet_dir, "sub-*"))

multi_session_study = False
if glob(os.path.join(args.pet_dir, "sub-*", "ses-*")):
    subjects = [subject_dir.split("-")[-1] for subject_dir in subject_dirs]
    for subject_label in subjects:
        session_dirs = glob(os.path.join(args.pet_dir, f"sub-{subject_label}", "ses-*"))
        sessions = [os.path.split(dr)[-1].split("-")[-1] for dr in session_dirs]
        n_valid_sessions = 0
        for session_label in sessions:
            if glob(os.path.join(args.bids_dir, f"sub-{subject_label}", f"ses-{session_label}", "anat", "*_T1w.nii*")):
                n_valid_sessions += 1
        if n_valid_sessions > 1:
            multi_session_study = True
            break

longitudinal_study = multi_session_study and (args.multiple_sessions == "longitudinal")

def find_pet_files(pet_directory, subject_label=None, session_label=None, tracer=None):
    """
    Find all PET NIfTI files for specified subjects, sessions, and tracers.

    Args:
        pet_directory (str): Root directory containing the PET data.
        subject_label (list of str): List of subject identifiers.
        session_label (list of str): List of session labels.
        tracer (str): Tracer name.

    Returns:
        dict: A dictionary with subject and session keys pointing to file paths.
    """
    pet_files = {}

    # List all subjects if none specified
    subjects = subject_label if subject_label else [os.path.basename(s).split('-')[-1] for s in glob(os.path.join(pet_directory, "sub-*"))]
    
    for subject in subjects:
        subject_pet_files = {}
        # List all sessions if none specified
        sessions = session_label if session_label else [os.path.basename(s).split('-')[-1] for s in glob(os.path.join(pet_directory, f"sub-{subject}", "ses-*"))]
        
        for session in sessions:
            # Construct the file pattern
            pattern = os.path.join(pet_directory, f"sub-{subject}", f"ses-{session}", "pet", f"sub-{subject}_ses-{session}_trc-{tracer}_pet.nii.gz")
            matched_files = glob(pattern)
            if matched_files:
                subject_pet_files[session] = matched_files
        
        if subject_pet_files:
            pet_files[subject] = subject_pet_files

    return pet_files

# Example usage
pet_files = find_pet_files(args.pet_dir, args.participant_label, args.session_label, args.tracer)
if pet_files:
    print("Found PET files:")
    for subject, sessions in pet_files.items():
        for session, files in sessions.items():
            print(f"Subject: {subject}, Session: {session}, Files: {files}")
else:
    print("No PET files found.")
