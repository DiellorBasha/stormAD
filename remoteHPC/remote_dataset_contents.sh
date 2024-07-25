#!/bin/bash

# Check if both directory arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <directory_to_list> <output_directory>"
    exit 1
fi

# Assign the arguments to variables
directory_to_list=$1
output_directory=$2

# Ensure the output directory exists
mkdir -p "$output_directory/dataset_content"

# List all directories and files recursively and save to the output file
find "$directory_to_list" -type d -name "anat" > "$output_directory/dataset_content/anatDirs.txt"
find "$directory_to_list" -type d -name "pet" > "$output_directory/dataset_content/petDirs.txt"
find "$directory_to_list" -type d -name "meg" > "$output_directory/dataset_content/megDirs.txt"

find "$directory_to_list" -type f -name "*_T1w.json" > "$output_directory/dataset_content/T1.txt"
find "$directory_to_list" -type f -name "*_T2star.json" > "$output_directory/dataset_content/T2.txt"
find "$directory_to_list" -type f -name "*_FLAIR.json" > "$output_directory/dataset_content/FLAIR.txt"

find "$directory_to_list" -type f -name "*_pet.json" > "$output_directory/dataset_content/pet.txt"
find "$directory_to_list" -type f -name "participants.tsv" > "$output_directory/dataset_content/subjects.txt"
find "$directory_to_list" -type f -name "dataset_description.json" > "$output_directory/dataset_content/datasetDescription.txt"