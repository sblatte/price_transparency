#!/bin/bash

INPUT_FILE=$1

# Find the base directory of the Git repository
REPO_BASE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)

echo "Starting the deletion of report files..."

while IFS= read -r TASK_NAME; do
    # Paths for report and code directories
    REPORT_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/report/"
    CODE_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/code/"

    # Check if both the report and code directories exist
    if [[ -d "$REPORT_DIR" && -d "$CODE_DIR" ]]; then
        echo "Deleting *.csv.log files in $REPORT_DIR"
        # Find and delete files ending with .csv.log
        find "$REPORT_DIR" -name '*.csv.log' -exec rm {} \; || { echo "Failed to delete report files in $REPORT_DIR"; exit 1; }
    else
        echo "Either $REPORT_DIR or $CODE_DIR does not exist, skipping..."
    fi
done < "$INPUT_FILE"


echo "Deletion complete."
