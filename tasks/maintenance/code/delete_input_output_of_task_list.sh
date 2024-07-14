#!/bin/bash

INPUT_FILE=$1

# Find the base directory of the Git repository
REPO_BASE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)

echo "Starting the deletion of input, output, and temp output directories..."
while IFS= read -r TASK_NAME; do
    # Paths for output, input, temp, and code directories
    OUTPUT_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/output/"
    INPUT_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/input/"
    TEMP_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/temp/"
    CODE_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/code/"  # Assuming 'code' directory

    # Skip task if code directory does not exist
    if [[ ! -d "$CODE_DIR" ]]; then
        echo "Skipping task $TASK_NAME as code directory does not exist."
        continue
    fi

    # Use quotes to handle directories with spaces or special characters
    # Also, check if the directory exists before attempting to delete
    if [[ -d "$OUTPUT_DIR" ]]; then
        echo "Deleting $OUTPUT_DIR"
        rm -r "$OUTPUT_DIR" || { echo "Failed to delete $OUTPUT_DIR"; exit 1; }
    fi

    if [[ -d "$INPUT_DIR" ]]; then
        echo "Deleting $INPUT_DIR"
        rm -r "$INPUT_DIR" || { echo "Failed to delete $INPUT_DIR"; exit 1;}
    fi

    if [[ -d "$TEMP_DIR" ]]; then
        echo "Deleting $TEMP_DIR"
        rm -r "$TEMP_DIR" || { echo "Failed to delete $TEMP_DIR"; exit 1;}
    fi

done < "$INPUT_FILE"

echo "Deletion complete."