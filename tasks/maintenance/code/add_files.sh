#!/bin/sh

# Set the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $current_branch"

# Move to git base directory for git commands to all work correctly
cd ../../../

# Arrays to hold the existing and non-existing files
existing_files=()
non_existing_files=()

# Loop through each matching directory
for directory in tasks/*/output; do
  #echo "Directory: $directory"

  # iterate over files non-existent in the current branch but present in main within the specified directory
  for file in $(git diff --name-only --diff-filter=D main "$current_branch" | grep 'output/'); do
    #echo "Checking file: $file"
    # check if file exists in the specified directory or any subdirectory
    if [ -f "$file" ]; then
      #echo "File exists, adding: $file"
      # if file exists, add it
      git add -f "$file"
      existing_files+=("$file")
    else
      #echo "File does not exist on $current_branch: $file"
      non_existing_files+=("$file")
    fi
  done
done

# Print all existing files
echo "Files that exist and were added:"
for file in "${existing_files[@]}"; do
  echo "$file"
done

# Print all non-existing files
echo "Files that do not exist on $current_branch:"
for file in "${non_existing_files[@]}"; do
  echo "$file"
done

cd tasks/maintenance/code