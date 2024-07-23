SHELL=bash

include ../../shell_functions.make

all: $(foreach year, $(shell seq 2011 2023), ../output/$(year)_chargemasters)  $(foreach year, $(shell seq 2015 2022), ../output/gaz$(year)zcta5centroid.csv)

include ../../generic.make


$(foreach year, 2022, ../output/$(year)_chargemasters):  ../output/%_chargemasters: | ../temp/chargemaster_raw_%.zip $(OOPR)
	unzip $(firstword $|) -d ../output/
	mv "../output/ChargemasterCDM-2022/2022 Completed Reviews/" ../output/2022_chargemasters/
	rmdir "../output/ChargemasterCDM-2022"
$(foreach year, 2023, ../output/$(year)_chargemasters):  ../output/%_chargemasters: | ../temp/chargemaster_raw_%.zip $(OOPR)
	unzip $(firstword $|) -d ../output/
	mv "../output/2023 Completed Reviews" ../output/2023_chargemasters
$(foreach year, 2019, ../output/$(year)_chargemasters):  ../output/%_chargemasters: | ../temp/chargemaster_raw_%.zip $(OOPR)
	unzip $(firstword $|) -d ../output/
	mv ../output/$* ../output/$*_chargemasters
$(foreach year, 2020 2021, ../output/$(year)_chargemasters):  ../output/%_chargemasters: | ../temp/%-hospital-chargemasters.zip $(OOPR)
	unzip $(firstword $|) -d ../output/$*
	mv ../output/$* ../output/$*_chargemasters
$(foreach year, $(shell seq 2011 2018), ../output/$(year)_chargemasters):  ../output/%_chargemasters: | ../temp/%-hospital-chargemasters.zip $(OOPR)
	unzip $(firstword $|) -d ../output/
	mv ../output/$* ../output/$*_chargemasters


$(foreach year, $(shell seq 2011 2018) 2020 2021, ../temp/$(year)-hospital-chargemasters.zip): | ../temp/chargemaster_raw_2011_2021.zip $(OOPR)
	unzip $(firstword $|) "$(notdir $@)" -d ../temp/

../temp/chargemaster_raw_2019.zip: | $(OOPR)
	wget https://data.chhs.ca.gov/dataset/0c315f3b-fc3c-4998-bd79-4659616c834d/resource/734ccb01-9b8e-4446-bb70-13718fb43a32/download/2019-hospital-chargemasters.zip -O $@
../temp/chargemaster_raw_2011_2021.zip: | $(OOPR)
	wget https://data.chhs.ca.gov/dataset/0c315f3b-fc3c-4998-bd79-4659616c834d/resource/363ba835-2be1-4426-abfa-15c357de1a3e/download/chargemasters-j5hprt.zip -O $@
../temp/chargemaster_raw_2022.zip: | $(OOPR)
	wget https://data.chhs.ca.gov/dataset/0c315f3b-fc3c-4998-bd79-4659616c834d/resource/62675919-d304-43e2-8575-3610664e6554/download/chargemastercdm-2022.zip -O $@
../temp/chargemaster_raw_2023.zip: | $(OOPR)
	wget https://data.chhs.ca.gov/dataset/0c315f3b-fc3c-4998-bd79-4659616c834d/resource/c56096d9-cd59-4179-958d-309110a44813/download/2023_hospital_chargemaster.zip -O $@


$(foreach year, 2015 2016, ../output/gaz$(year)zcta5centroid.csv): ../output/gaz%zcta5centroid.csv: | $(OOPR)
	wget https://data.nber.org/distance/$*/gaz/zcta5/gaz$*zcta5centroid.csv -O $@

$(foreach year, $(shell seq 2017 2022), ../output/gaz$(year)zcta5centroid.csv): ../output/gaz%zcta5centroid.csv: | $(OOPR)
	wget https://data.nber.org/distance/$*/centroid/gaz$*zcta5centroid.csv -O $@

$(foreach year, $(shell seq 2011 2023), ../output/$(year)): ../output/%: | ../output
	mkdir $@