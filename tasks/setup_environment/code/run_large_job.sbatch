#!/bin/bash

#SBATCH --output=slurmlogs/%x_%j.out
#SBATCH --error=slurmlogs/%x_%j.err
#SBATCH --time=10:00:00
#SBATCH --mem=100gb
#SBATCH --partition=tier3q
#SBATCH --mail-type=FAIL

# Load necessary modules
$command1

# Run the code
$command2 || {
  echo "Job failed with exit code $?"
  echo "Job details:"
  sacct -j $SLURM_JOBID --format=JobID,JobName,AllocCPUS,Elapsed,State,ExitCode,MaxRSS,AveVMSize,MaxDiskRead,MaxDiskWrite
  exit 1
}

# Need to print something so makefile knows job isn't done 
# Print out total elapsed time
echo "Total Elapsed Time:"
sacct -j $SLURM_JOB_ID --format=JobID,Elapsed --noheader | grep "^[0-9]" | awk '{print $2}' | awk -F: '{ sec=($1*3600)+($2*60)+$3 } END {printf "Elapsed time: %d:%02d:%02d\n", sec/3600, (sec/60)%60, sec%60}'
