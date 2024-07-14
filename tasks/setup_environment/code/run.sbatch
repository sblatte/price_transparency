#!/bin/bash

#SBATCH --output=slurmlogs/%x_%j.out
#SBATCH --error=slurmlogs/%x_%j.err
#SBATCH --time=10:00:00
#SBATCH --mem=10gb
#SBATCH --mail-type=FAIL
#SBATCH --partition=tier1q

# Load necessary modules
$command1

# Run the code
$command2

# Need to print something so makefile knows job isn't done 
# Print out total elapsed time
echo "Total Elapsed Time:"
sacct -j $SLURM_JOB_ID --format=JobID,Elapsed --noheader | grep "^[0-9]" | awk '{print $2}' | awk -F: '{ sec=($1*3600)+($2*60)+$3 } END {printf "Elapsed time: %d:%02d:%02d\n", sec/3600, (sec/60)%60, sec%60}'
