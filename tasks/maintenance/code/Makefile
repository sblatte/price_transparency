SHELL=bash

all: lineendings gtoolscheck stata_packages remove_deleted_branches style_checks

# All folders downstream of this folder will be modified by duplicate_folders.sh
DUPLICATE_FOLDER = collapse_data

TASK = geo_characteristics

include ../../generic.make

../output/col_diff_list.txt: compare_cols.sh | $(OOPR)
	sh compare_cols.sh

lineendings:
	bash lineendings.sh
lineendings_convert:
	bash lineendings_convert.sh
gtoolscheck:
	bash gtoolscheck.sh
stata_packages:
	bash stata_packages.sh
remove_deleted_branches:
	bash remove_deleted_branches.sh
style_checks:
	bash style_checks.sh
makefiles_undefined_variables:
	bash makefiles_undefined_variables.sh

# Run make duplicate to execute this target
duplicate: ../output/dependent_on_$(DUPLICATE_FOLDER).txt

../output/dependent_on_$(DUPLICATE_FOLDER).txt: duplicate_folders.sh | ../output
	bash duplicate_folders.sh $(DUPLICATE_FOLDER)

# List tasks downstream of a specified task, ordered from upstream to downstream
../output/downstream_of_$(TASK).txt: find_downstream_of_task.sh | ../output
	bash find_downstream_of_task.sh $(TASK)

# List all tasks that run on the repo, ordered from upstream to downstream
../output/downstream_tasks.txt: find_all_downstream_tasks.sh | ../output
	bash find_all_downstream_tasks.sh

# Delete all input, output, and temp folders in tasks downstream of specified task
# Must include task name when calling target to avoid inadvertent deletions
delete_downstream_of_$(TASK)_input_output: delete_input_output_of_task_list.sh ../output/downstream_of_$(TASK).txt
	bash delete_input_output_of_task_list.sh ../output/downstream_of_$(TASK).txt

# Delete all input, output, and temp folders in tasks that run on the repo
delete_all_downstream_input_output: delete_input_output_of_task_list.sh ../output/downstream_tasks.txt
	bash delete_input_output_of_task_list.sh ../output/downstream_tasks.txt

# Delete csv reports downstream of specified task
delete_csv_reports_downstream_of_$(TASK): delete_csv_reports_of_task_list.sh ../output/downstream_of_$(TASK).txt
	bash delete_csv_reports_of_task_list.sh ../output/downstream_of_$(TASK).txt

# Delete all csv reports generated in repo
delete_csv_reports_downstream: delete_csv_reports_of_task_list.sh ../output/downstream_tasks.txt
	bash delete_csv_reports_of_task_list.sh ../output/downstream_tasks.txt

# Rerun all tasks downstream of specified task
rerun_downstream_of_$(TASK): rerun_task_list.sh  ../output/downstream_of_$(TASK).txt | ../output
	bash rerun_task_list.sh ../output/downstream_of_$(TASK).txt

# Rerun all tasks in repo
rerun_all_downstream: rerun_task_list.sh  ../output/downstream_tasks.txt |../output
	bash rerun_task_list.sh ../output/downstream_tasks.txt

# Remake csv reports downstream of task
# Note that you must be in an interactive session
rerun_reports_downstream_of_$(TASK): rerun_reports_task_list.sh  ../output/downstream_of_$(TASK).txt | ../output
	bash rerun_reports_task_list.sh ../output/downstream_of_$(TASK).txt

# Remake all csv reports made on repo
# Note that you must be in an interactive session
rerun_downstream_reports: rerun_reports_task_list.sh ../output/downstream_tasks.txt | ../output
	bash rerun_reports_task_list.sh ../output/downstream_tasks.txt

# Start an interactive session
interactive_session: start_interactive_session.sh  
	bash start_interactive_session.sh