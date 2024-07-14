#!/bin/bash

# Check if the script is running in an interactive session
if ! [ -t 0 ]; then
    echo "Not in interactive session. Must run make interactive_session before remaking csv reports"
    exit 1
fi

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

    echo "Starting the report build phase..."
    # Path for the file where tasks with errors will be recorded
    ERRORS_FILE="../output/tasks_with_report_make_errors.txt"
    # Ensure the file is empty to start with
    > "$ERRORS_FILE"

    while IFS= read -r TASK_NAME; do
        CODE_DIR="${REPO_BASE_PATH}/tasks/${TASK_NAME}/code/"

        if [[ -d "$CODE_DIR" ]]; then
            # Check if there is a recipe to make reports
            if (cd "$CODE_DIR" && make -n reports &> /dev/null); then
                echo "Running make reports with -k in $CODE_DIR"
                if ! (cd "$CODE_DIR" && make reports -k -j 2); then
                    echo "Make encountered errors in $CODE_DIR"
                    echo "$TASK_NAME" >> "$ERRORS_FILE"
                fi
            else
                echo "No recipe to make reports in $CODE_DIR. Skipping..."
            fi
        else
            echo "Code directory $CODE_DIR does not exist. Skipping..."
        fi
    done < "$INPUT_FILE"

    # Check if the error file is not empty, indicating there were errors
    if [ -s "$ERRORS_FILE" ]; then
        echo "The report build phase completed with errors. Tasks with errors have been recorded in $ERRORS_FILE"
        exit 1
    else
        echo "The report build phase completed without any errors."
    fi
} 2>&1 | tee "$OUTPUT_FILE"
