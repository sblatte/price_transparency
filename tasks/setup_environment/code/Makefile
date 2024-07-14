SHELL=bash
include ../../shell_functions.make

all: $(foreach lang,stata R python,../output/$(lang)_packages.txt) \
    ../output/stata_setup.txt

include ../../generic.make

../output/stata_setup.txt: stata_setup.do | $(OOPR)
	$(STATA) $<
../output/julia_packages.txt: packages.jl ../output/Project.toml ../output/Manifest.toml | $(OOPR)
	$(JULIA) $<
../output/stata_packages.txt: packages.do save_data/save_data.ado | $(OOPR)
	$(STATA) $<
../output/R_packages.txt: packages.R | $(OOPR)
	$(R) $<
../output/python_packages.txt: requirements.txt | $(OOPR)
	$(PIP) $<
	echo "python packages installed" > $@
