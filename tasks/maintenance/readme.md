# Maintenance
This task contains utilities useful for the maintenance of the code and repo. 

## Tools related to assessing changes on a (rerun) branch

The following scripts are not implemented as Make recipes but may also be useful on a rerun branch.

- `add_files.sh` commits all outputs which are on `main` and saved locally but not committed to the current branch. 
This script must be run from within `tasks/maintenance/code` as it uses `cd`. 
This script should be updated at some point to not use `cd` so that it is robust to the users' current working directory.

- `compare_cols.sh` compares the first three lines in `.tex` outputs with regression columns that are in the current branch and `main`. 
If there are differences in the first three lines, it prints the diff, allowing the user to see differences in the number and names of columns. 
It also saves a list of the columns with differences to the output folder.
This script is run from `Makefile` by calling `make ../output/col_diff_list.txt`.
This script must also be run from within `tasks/maintenance/code` as it uses `cd`. 
This script should be updated at some point to not use `cd`.

- `view_changed_files.sh` opens, one by one, all modified files with a specified file extension on to contrast the version on the main branch and that on the current branch. 
As written, this will only work on Mac because of the `open` command. It must be run from the root directory and invoke bash `tasks/maintenance/code/view_changed_files.sh`.

The following scripts are implemented as Make recipes:
- duplicate: Creates a duplicate of data folders, specified by DUPLICATE_FOLDER, using `duplicate_folders.sh`.
- downstream_of_TASK: Lists tasks dependent on the specified TASK, ordered from upstream to downstream, using `find_downstream_of_task.sh`.
- downstream_tasks: Enumerates all tasks in the repository in the order they run, using `find_all_downstream_tasks.sh`.
- delete_downstream_of_TASK_input_output: Deletes all input, output, and temp folders in tasks dependent on TASK, using `delete_input_output_of_task_list.sh`.
- delete_all_downstream_input_output: Removes all input, output, and temp folders in tasks running in the repository, using `delete_input_output_of_task_list.sh`.
- delete_csv_reports_downstream_of_TASK: Deletes CSV reports for tasks downstream of TASK, using `delete_csv_reports_of_task_list.sh`.
- delete_csv_reports_downstream: Removes all CSV reports generated in the repository, using `delete_csv_reports_of_task_list.sh`.
- rerun_downstream_of_TASK: Reruns all tasks dependent on TASK, using `rerun_task_list.sh`.
- rerun_all_downstream: Executes all tasks in the repository again, using `rerun_task_list.sh`.
- rerun_reports_downstream_of_TASK: Regenerates CSV reports for tasks downstream of TASK, requiring an interactive session, using `rerun_reports_task_list.sh`.
- rerun_downstream_reports: Creates all CSV reports anew in the repository, necessitating an interactive session, with `rerun_reports_task_list.sh`.
- interactive_session: Starts an interactive session for executing certain tasks, using `start_interactive_session.sh`.

For detailed instructions on each recipe, refer to their respective shell scripts. 

## Tools for reviewing code
- lineendings: Lists files that have Windows line endings using `lineendings.sh`.
- lineendings_convert: Converts Windows line endings to Unix line endings for readme and files in `code` folders using `lineendings_convert.sh`.
- gtoolscheck: Verifies the installation and functionality of required GTools using `gtoolscheck.sh`.
- stata_packages: Installs and updates necessary Stata packages using `stata_packages.sh`. It is not exhaustive and currently only searches for `reghdfe`, `ppmlhdfe`, and `distinct`
- remove_deleted_branches: Identifies and removes deleted branches using `remove_deleted_branches.sh`
- style_checks: Lists the names of stata scripts and makefiles that do not meet certain style guidelines using `style_checks.sh`
- makefiles_undefined_variables: Runs `make -nC` on all tasks looking for undefined variable warnings using `makefiles_undefined_variables.sh`
