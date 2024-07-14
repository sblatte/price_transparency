# This program opens, one at a time, the versions of all modified files 
# with a specified file name ending on main and the current branch to compare.
# As written, this will only work on Mac because of the "open" command.

# Step 1: Set extension to check
ext='eps'

# Step 2: Get the list of modified .eps files
#modified_files=$(git diff --name-only --relative=$(git rev-parse --show-prefix) main -- '*.'${ext})
modified_files=$(git diff --name-status --relative=$(git rev-parse --show-prefix) main -- '*.'${ext} | grep '^M' | sed 's/^M[[:space:]]*//')

# Step 3: Initialize counter
total_files=$(echo "$modified_files" | wc -l)
current_file=1

# Step 4: Process each modified file
for file in $modified_files; do
  echo "Processing file $current_file of $total_files: $file"
  echo "Press V to view the file, or any other key to skip."
  read -n 1 -s -r key
  if [[ $key != "v" && $key != "V" ]]; then
    ((current_file++))
    continue
  fi

  # Step 5: Rename the local file
  mv "$file" "${file%.$ext}.new.$ext"

  # Step 6: Check out the file from the main branch
  git checkout main -- "$file"

  # Step 7: Open the old and new versions in Preview
  open "$file" "${file%.$ext}.new.$ext"

  # Step 8: Wait for the viewer to close
  read -p "Press Enter to continue once you're done comparing."
  mv "${file%.$ext}.new.$ext" "$file"

  # Step 9: Move on to the next file
  ((current_file++))
done

