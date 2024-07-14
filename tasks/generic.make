OOPR = ../output ../temp ../report ../input $(if $(shell command -v sbatch),run.sbatch) #Order-only pre-reqs
JULIA_OOPR = ../output ../input/Project.toml $(if $(shell command -v sbatch),run.sbatch) #Order-only pre-reqs for running julia scripts 

../output ../report ../temp ../input slurmlogs ../temp_report:
	mkdir $@

run.sbatch: ../../setup_environment/code/run.sbatch | slurmlogs
	ln -sf $< $@
run_large_job.sbatch: ../../setup_environment/code/run_large_job.sbatch | slurmlogs
	ln -sf $< $@

../input/Project.toml: ../../setup_environment/output/Project.toml | ../input/Manifest.toml ../input
	ln -sf $< $@
../input/Manifest.toml: ../../setup_environment/output/Manifest.toml | ../input
	ln -sf $< $@

.PRECIOUS: ../../%

../../%: #Generic recipe to produce outputs from upstream tasks
	$(MAKE) -C $(subst output/,code/,$(dir $@)) ../output/$(notdir $@)

.PHONY: wipe

wipe:
	$(WIPE)

../report/%.csv.log: ../output/%.csv | ../report
ifneq ($(shell command -v md5),)
	cat <(md5 -r $<) <(echo -n 'Lines:') <(cat $< | wc -l | xargs) <(head -3 $<) <(echo '...') <(tail -2 $<)  > $@
else
	cat <(md5sum $< | sed 's/  / /') <(echo -n 'Lines:') <(cat $< | wc -l) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
endif
	cat $< | sed -e :a -e 's/"\([^"]*\),\([^"]*\)"/"\1\2"/g;ta' | gawk -f ../../get_averages_csv.awk >> $@


../temp_report/%.csv.log: ../temp/%.csv | ../temp_report
ifneq ($(shell command -v md5),)
	cat <(md5 $<) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<)  > $@
else
	cat <(md5sum $<) <(echo -n 'Lines:') <(cat $< | wc -l ) <(head -3 $<) <(echo '...') <(tail -2 $<) > $@
endif
	cat $< | sed -e :a -e 's/"\([^"]*\),\([^"]*\)"/"\1\2"/g;ta' | gawk -f ../../get_averages_csv.awk >> $@
