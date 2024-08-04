SHELL=bash
include ../../shell_functions.make

all: ../output/CPI-U.dta

include ../../generic.make

../output/CPI-U.dta: download_cpi.R | $(OOPR)
		$(R) $<
