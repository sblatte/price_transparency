#!/bin/bash

# Set the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $current_branch"

# Move to git base directory for git commands to all work correctly
cd ../../../

# Define the base directory
BASE_DIR=$(pwd)

# Create or clear the output file
echo "" > tasks/maintenance/output/col_diff_list.txt

#Make temp outputs
touch tasks/maintenance/temp/temp_main.txt tasks/maintenance/temp/temp_rerun.txt

# Loop through every file that matches the pattern: tasks/*/output/*.tex
for file in $(find tasks -type f -path "*/output/*.tex"); do
    # Get the relative file path
    RELATIVE_PATH=${file#$BASE_DIR/}
    
    # Skip the file if it does not exist in the current branch
    if ! git ls-tree -r "$current_branch" --name-only | grep -q "^$RELATIVE_PATH$"; then
        continue
    fi
    
    # Search the file to see if there is a row that begins with " & (1)"
    if grep -q "^ & (1)" "$file"; then

        # Get the first two lines of the file from the main branch
        MAIN_CONTENT=$(git show main:"$RELATIVE_PATH" | head -n 3)

        # Get the first two lines of the file from the current branch
        RERUN_CONTENT=$(git show "$current_branch":"$RELATIVE_PATH" | head -n 3)

        # Write the lines to temporary files
        echo "$MAIN_CONTENT" > tasks/maintenance/temp/temp_main.txt
        echo "$RERUN_CONTENT" > tasks/maintenance/temp/temp_rerun.txt
        # Check if there is a difference between the first two lines of the files
        if ! diff -q tasks/maintenance/temp/temp_main.txt tasks/maintenance/temp/temp_rerun.txt > /dev/null 2>&1; then
            # Print the diff if there is a difference
            echo "Diff for first two lines of $RELATIVE_PATH between main and $current_branch:"
            diff tasks/maintenance/temp/temp_main.txt tasks/maintenance/temp/temp_rerun.txt
            # Append the relative file path to the text file
            echo "$RELATIVE_PATH" >> tasks/maintenance/output/col_diff_list.txt
        fi
    fi
done
# Cleanup temporary files
rm tasks/maintenance/temp/temp_main.txt tasks/maintenance/temp/temp_rerun.txt

cd tasks/maintenance/code
