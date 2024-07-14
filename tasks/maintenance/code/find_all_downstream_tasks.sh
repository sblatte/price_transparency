#!/bin/bash

# Script to generate a list of all downstream tasks from a given start task
# and to create a graph of tasks.

OUTPUT_FILE="../output/downstream_tasks.txt"
REPO_BASE_PATH=$(git rev-parse --show-toplevel 2>/dev/null)
GRAPH_FILE="../output/graph_all.txt"

# Check if we are in a git repository
if [ -z "$REPO_BASE_PATH" ]; then
    echo "Error: Must be run inside a git repository."
    exit 1
fi
echo "Repository base path: $REPO_BASE_PATH"

# Generate the graph file
echo -e 'digraph G {' > "$GRAPH_FILE"

find ../../*/code -name "Makefile" | xargs grep -o 'input.*:.*output' |
sed 's/\.\.\/\.\.\///g' | # Drop leading relative path ../../ from start of line
sed 's/\/code\/Makefile:input.*:/ \->/' | sed 's/\/output$//' | sed 's/ | / /' | # Drop folders and file names; show only tasks
awk -F' -> ' '{ print $2 " -> " $1}' | # Flip order to reflect task flow, not symbolic link direction
sort | uniq >> "$GRAPH_FILE"

echo '}' >> "$GRAPH_FILE"

# Add function to get downstream tasks
get_downstream_tasks() {
    local task="$1"
    local visited="$2"

    grep "^$task ->" "$GRAPH_FILE" | sed "s/$task -> //g" | while read downstream_task; do
        if ! grep -q "$downstream_task" <<< "$visited"; then
            echo "$downstream_task"
            visited="$visited"$'\n'"$downstream_task"
            get_downstream_tasks "$downstream_task" "$visited"
        fi
    done
}

# Extract upper nodes (left side of `->`) and lower nodes (right side of `->`)
upper_nodes=$(awk -F' -> ' '/ -> /{gsub(/^ +| +$/, "", $1); print $1}' "$GRAPH_FILE" | sort -u)
lower_nodes=$(awk -F' -> ' '/ -> /{gsub(/^ +| +$/, "", $2); print $2}' "$GRAPH_FILE" | sort -u)

# Identify top-level nodes (nodes in upper but not in lower)
top_level_nodes=$(comm -23 <(echo "$upper_nodes") <(echo "$lower_nodes"))

# Initialize an empty string to collect all downstream tasks
all_downstream_tasks=""

# Iterate over each top-level node
for start_task in $top_level_nodes; do
    # Check if the code folder exists for the top-level node
    if [ -d "$REPO_BASE_PATH/tasks/$start_task/code/" ]; then
        # If it exists, add the node to the list
        all_downstream_tasks="$all_downstream_tasks"$'\n'"$start_task"
    fi
    
    visited="$start_task"
    downstream_tasks=$(get_downstream_tasks "$start_task" "$visited")
    all_downstream_tasks="$all_downstream_tasks"$'\n'"$downstream_tasks"
done

# Save the downstream tasks to file, removing duplicates
echo "$all_downstream_tasks" | awk '!seen[$0]++' > "$OUTPUT_FILE"

echo "The list of downstream tasks has been saved to $OUTPUT_FILE"
