#!/bin/bash
# Script to create duplicates for all tasks downstream of a given task
# The start task is provided as the first command line argument.
# The output is saved to ../output/dependent_on_<start_task>.txt.

START_TASK=$1

if [ -z "$START_TASK" ]; then
    echo "Usage: $0 <start-task>"
    exit 1
fi

# Sanitize the start task name to create a valid filename
FILENAME=$(echo "$START_TASK" | sed 's/[^a-zA-Z0-9_]/_/g')
OUTPUT_FILE="../output/dependent_on_${FILENAME}.txt"
# Find the base directory of the Git repository
REPO_BASE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)

# Check if we are in a git repository
if [ -z "$REPO_BASE_PATH" ]; then
    echo "Error: Must be run inside a git repository."
    exit 1
fi
echo "Repository base path: $REPO_BASE_PATH"

# Generate the graph file
echo -e 'digraph G {' > ../output/graph.txt

find ../../*/code -name "Makefile" | xargs grep -o 'input.*:.*output' |
sed 's/\.\.\/\.\.\///g' | #Drop leading relative path ../../ from start of line
sed 's/\/code\/Makefile:input.*:/ \->/' | sed 's/\/output$//' | sed 's/ | / /' | #Drop folders and file names; show only tasks
awk -F' -> ' '{ print $2 " -> " $1}' | #Flip order to reflect task flow, not symbolic link direction
sort | uniq >> ../output/graph.txt

echo '}' >> ../output/graph.txt

##############

GRAPH_FILE="../output/graph.txt"
# Add this function to your script

get_downstream_tasks() {
    local task="$1"
    local visited="$2"

    # Look for tasks that are directly downstream of the current task
    # and add them to the list if not already visited
    grep "^$task ->" "$GRAPH_FILE" | sed "s/$task -> //g" | while read downstream_task; do
        if ! grep -q "$downstream_task" <<< "$visited"; then
            echo "$downstream_task"
            # Mark this task as visited
            visited="$visited"$'\n'"$downstream_task"
            # Recursively get downstream tasks
            get_downstream_tasks "$downstream_task" "$visited"
        fi
    done
}

# Initialize visited with the start task to prevent it from being listed
visited="$START_TASK"

# Get the list of downstream tasks and then save to file
# Save in order of traversal, dropping duplicates
get_downstream_tasks "$START_TASK" "$visited" | awk '!seen[$0]++' > "$OUTPUT_FILE"
# add this task to the list
echo "The list of downstream tasks has been saved to $OUTPUT_FILE"

INPUT_FILE=$OUTPUT_FILE

# Find the base directory of the Git repository
REPO_BASE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)

echo "Starting to copy folders..."
while IFS= read -r TASK_NAME; do
    # Paths for output, input, temp, and code directories
    CODE_DIR="$REPO_BASE_PATH/tasks/$TASK_NAME/code/"  # Assuming 'code' directory
    NEW_TASK="${TASK_NAME}_physn_zip"
    # Skip task if code directory does not exist
    if [[ ! -d "$CODE_DIR" ]]; then
        echo "Skipping task $TASK_NAME as code directory does not exist."
        continue
    fi

    # Use quotes to handle directories with spaces or special characters
    # Also, check if the directory exists before attempting to delete
    if [[ -d "$CODE_DIR" ]]; then
        if [[ ! -d "$REPO_BASE_PATH/tasks/$NEW_TASK" ]]; then
            allfiles=""
            mkdir $REPO_BASE_PATH/tasks/$NEW_TASK
            mkdir $REPO_BASE_PATH/tasks/$NEW_TASK/code
            cp $REPO_BASE_PATH/tasks/$TASK_NAME/code/Makefile $REPO_BASE_PATH/tasks/$NEW_TASK/code/Makefile
            files_to_link=($(find "$REPO_BASE_PATH/tasks/$TASK_NAME/code" -type f \( -name "*.do" -o -name "*.R" -o -name "*.py" -o -name "*.jl" \)))
            for file in "${files_to_link[@]}"; do
                # Extract the filename without the path
                filename=$(basename "$file")
                # Create a symbolic link in the destination directory
                echo -e "\n${filename}: ../../$TASK_NAME/code/$filename\n\tln -sf \$< \$@" >> ../../$NEW_TASK/code/Makefile
                echo "Wrote symbolic link for $filename to Makefile"
                allfiles="$allfiles $filename"
            done
            echo "code: ${allfiles}" >> ../../$NEW_TASK/code/Makefile
            echo ".PHONY: code" >> ../../$NEW_TASK/code/Makefile
            sed -i.bak "s,all:,all: code,g" "../../$NEW_TASK/code/Makefile"
            rm ../../$NEW_TASK/code/Makefile.bak
        else
            echo "$NEW_TASK already exist. Skipping..."
        fi
    fi
done < "$INPUT_FILE"

echo "Copying complete."
# Change makefile paths to point towards new outputs
# Search for subdirectories containing the phrase "zip"
zip_subdirectories=$(find ../../ -type d -name "*physn_zip*")

# Loop through each subdirectory found
for zip_subdirectory in $zip_subdirectories; do
    # Execute the symbolic links
    make -C ${zip_subdirectory}/code code
    # Loop through each task to change including the start task which may not appear in the find command
    # if you manually make the new folder first, it will. But this ensures you don't have to
    for zip_name in $zip_subdirectories "../../$START_TASK"; do
        name=$(echo "$zip_name" | sed 's/_physn_zip//')
        sed -i.bak "s,$name/output,${name}_physn_zip/output,g" "$zip_subdirectory/code/Makefile"
        rm $zip_subdirectory/code/Makefile.bak
        echo "Modified Makefile in $zip_subdirectory"
    done
done

# Make the 