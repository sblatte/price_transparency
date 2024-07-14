FUNCTIONS = $(shell cat ../../shell_functions.sh)
PYTHON = @$(FUNCTIONS); python_pc_and_slurm
PYTHON_LARGE_JOB = @$(FUNCTIONS); python_pc_and_slurm_large_job
R = @$(FUNCTIONS); R_pc_and_slurm
JULIA = @$(FUNCTIONS); julia_pc_and_slurm
STATA_BATCH = @$(FUNCTIONS); stata_pc_and_slurm
STATA = @$(FUNCTIONS); stata_with_flag
WIPE = @$(FUNCTIONS); wipe_directory
PUSH = @$(FUNCTIONS); push_ignore_paths
PULL = @$(FUNCTIONS); pull_ignore_paths
PIP = @$(FUNCTIONS); pip_install_pc_and_slurm

#If 'make -n' option is invoked
ifneq (,$(findstring n,$(MAKEFLAGS)))
PYTHON := PYTHON
PYTHON_LARGE_JOB := PYTHON_LARGE_JOB
R := R
JULIA := JULIA
STATA_BATCH := STATA
STATA := STATA
WIPE := wipe_directory
PUSH := push_ignore_paths
PULL := pull_ignore_paths
PIP = PIP produce $@ using
endif
