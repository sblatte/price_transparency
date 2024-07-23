SHELL=bash

include ../../shell_functions.make


all: $(foreach year, $(shell seq 2013 2022), ../output/trimmed_provider_data_$(year).dta)


include ../../generic.make


$(foreach year, $(shell seq 2013 2022), ../output/trimmed_provider_data_$(year).dta): ../output/trimmed_provider_data_%.dta: load_and_trim.py $(foreach year, $(shell seq 2013 2022), ../input/physician_procedure_raw_$(year).csv) | $(OOPR)
	$(PYTHON) $< $*

../input/physician_procedure_raw_2013.csv: ../../downloaddata/output/provider_data/2013/MUP_PHY_R19_P04_V10_D13_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2014.csv: ../../downloaddata/output/provider_data/2014/MUP_PHY_R19_P04_V10_D14_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2015.csv: ../../downloaddata/output/provider_data/2015/MUP_PHY_R19_P04_V10_D15_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2016.csv: ../../downloaddata/output/provider_data/2016/MUP_PHY_R19_P04_V10_D16_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2017.csv: ../../downloaddata/output/provider_data/2017/MUP_PHY_R19_P04_V10_D17_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2018.csv: ../../downloaddata/output/provider_data/2018/MUP_PHY_R20_P04_V10_D18_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2019.csv: ../../downloaddata/output/provider_data/2019/MUP_PHY_R21_P04_V10_D19_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2020.csv: ../../downloaddata/output/provider_data/2020/MUP_PHY_R22_P05_V10_D20_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2021.csv: ../../downloaddata/output/provider_data/2021/MUP_PHY_R23_P05_V10_D21_Prov_Svc.csv | ../input
	ln -sf $< "$@"
../input/physician_procedure_raw_2022.csv: ../../downloaddata/output/provider_data/2022/MUP_PHY_R24_P05_V10_D22_Prov_Svc.csv | ../input
	ln -sf $< "$@"