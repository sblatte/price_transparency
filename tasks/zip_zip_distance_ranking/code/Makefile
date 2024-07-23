SHELL=bash

include ../../shell_functions.make


all: $(foreach year, $(shell seq 2013 2022), ../output/nearby_hospitals_$(year).dta)


include ../../generic.make

$(foreach year, $(shell seq 2013 2022), ../output/nearby_hospitals_$(year).dta): ../output/nearby_hospitals_%.dta: rank_nearby_hospitals.R  ../input/trimmed_provider_data_%.dta $(foreach year, 2015 2016 2017 2018 2019 2020 2021 2022, ../input/gaz$(year)zcta5centroid.csv)  $(foreach year, $(shell seq 13 22), ../input/MUP_INP_RY24_P04_V10_DY$(year)_Prv.csv) | $(OOPR)
	$(R) $< $*




../input/gaz%zcta5centroid.csv: ../../downloaddata/output/gaz%zcta5centroid.csv | ../input
	ln -sf $< $@
../input/trimmed_provider_data_%.dta: ../../clean_provider_data/output/trimmed_provider_data_%.dta | ../input
	ln -sf $< $@


$(foreach year, $(shell seq 13 22), ../input/MUP_INP_RY24_P04_V10_DY$(year)_Prv.csv): ../input/MUP_INP_RY24_P04_V10_DY%_Prv.csv: | ../input
	ln -sf ../../downloaddata/output/hospitals_only/20$*/MUP_INP_RY24_P04_V10_DY$*_Prv.CSV $@