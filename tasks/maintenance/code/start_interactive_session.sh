#!/bin/bash

# This script starts an interactive job on a Slurm-managed system

# Set Slurm parameters
PARTITION="tier2q"
MEMORY="125G"
TIME_LIMIT="12:00:00"

# Start an interactive session
echo "Starting an interactive job that lasts $TIME_LIMIT on partition $PARTITION with $MEMORY of memory."
srun --partition="$PARTITION" --mem="$MEMORY" --time="$TIME_LIMIT" --pty bash -l
