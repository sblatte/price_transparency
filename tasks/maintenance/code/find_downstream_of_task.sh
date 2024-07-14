#!/bin/bash
# Script to generate a list of all downstream tasks from a given start task.
# The start task is provided as the first command line argument.
# The output is saved to ../output/downstream_of_<start_task>.txt.

START_TASK=$1

if [ -z "$START_TASK" ]; then
    echo "Usage: $0 <start-task>"
    exit 1
fi

# Sanitize the start task name to create a valid filename
FILENAME=$(echo "$START_TASK" | sed 's/[^a-zA-Z0-9_]/_/g')
OUTPUT_FILE="../output/downstream_of_${FILENAME}.txt"

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

echo "The list of downstream tasks has been saved to $OUTPUT_FILE"
