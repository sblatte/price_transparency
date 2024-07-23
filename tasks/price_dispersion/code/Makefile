SHELL=bash

include ../../shell_functions.make

all: ../output/disperion_variance.pdf

include ../../generic.make

../output/disperion_variance.pdf: price_dispersion.do $(foreach year, $(shell seq 2013 2022), ../input/trimmed_provider_data_$(year).dta) | $(OOPR)
	$(STATA) $<

$(foreach year, $(shell seq 2013 2022), ../input/trimmed_provider_data_$(year).dta): ../input/trimmed_provider_data_%.dta: ../../clean_provider_data/output/trimmed_provider_data_%.dta | ../input
	ln -sf $< $@

