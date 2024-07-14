#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE="../output/rerun_of_$(basename "$INPUT_FILE").csv"

# Find the base directory of the Git repository
REPO_BASE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)

# Redirect stdout and stderr to both the screen and the output file
{
    # Check if we are in a git repository
    if [ -z "$REPO_BASE_PATH" ]; then
        echo "Error: Must be run inside a git repository."
        exit 1
    fi
    echo "Repository base path: $REPO_BASE_PATH"

    echo "Starting the build phase..."
    # Path for the file where tasks with errors will be recorded
    ERRORS_FILE="../output/tasks_with_make_errors.txt"
    # Ensure the file is empty to start with
    > "$ERRORS_FILE"

    # Define the list of tasks to skip
    SKIP_TASKS=("scale_elasticity_estimation_onestep" "FC_calculations" "gravity_analysis_proxy" "avg_dist_export" "teaching_distribution")


    while IFS= read -r TASK_NAME; do
        # Check if the task is in the skip list
        if [[ " ${SKIP_TASKS[@]} " =~ " ${TASK_NAME} " ]]; then
            echo "Skipping task ${TASK_NAME}"
            continue
        fi

        CODE_DIR="${REPO_BASE_PATH}/tasks/${TASK_NAME}/code/"

        if [[ -d "$CODE_DIR" ]]; then
            echo "Checking for .do files in $CODE_DIR"

            # Count the number of .do files in the directory
            DO_FILE_COUNT=$(find "$CODE_DIR" -maxdepth 1 -name '*.do' | wc -l)

            # Determine which make command to run based on task name and presence of .do files
            if [[ $DO_FILE_COUNT -gt 0 ]] || [[ $TASK_NAME == *"gravity_analysis"* ]] || [[ $TASK_NAME == *"scale_elasticity"* ]]; then
                echo "Running make with -k in $CODE_DIR"
                MAKE_COMMAND="make -k"
            else
                echo "Running make with -k -j 10 in $CODE_DIR"
                MAKE_COMMAND="make -k -j 10"
            fi

            # Run the appropriate make command
            if ! (cd "$CODE_DIR" && $MAKE_COMMAND); then
                echo "Make encountered errors in $CODE_DIR"
                # Record task with error
                echo "$TASK_NAME" >> "$ERRORS_FILE"
            fi
        else
            echo "Code directory $CODE_DIR does not exist. Skipping..."
        fi
    done < "$INPUT_FILE"


    # Check if the error file is not empty, indicating there were errors
    if [ -s "$ERRORS_FILE" ]; then
        echo "The build phase completed with errors. Tasks with errors have been recorded in $ERRORS_FILE"
        exit 1
    else
        echo "The build phase completed without any errors."
    fi
} 2>&1 | tee "$OUTPUT_FILE"
