clear all

//warning: at one point, gtools had to be compiled manually for M1 Macs
//see https://github.com/mcaceresb/stata-gtools/issues/73#issuecomment-803444445

// Make personal stata folder if it doesn't exist
capture confirm file `c(sysdir_personal)'
if _rc != 0 shell mkdir -p `c(sysdir_personal)'

ado update // First run ado update without the `update` option to clean up duplicated packages. See https://www.stata.com/manuals13/radoupdate.pdf for details.

// install from ssc
local PACKAGES gtools estout egenmore 

foreach package in `PACKAGES' {
	// Handle packages that do not match command names
	if "`package'" == "lassopack" local command = "lasso2"
	else if "`package'" == "egenmore" local command = "egen"
	else if "`package'" == "blindschemes" local command = "scheme-plotplain.scheme"
	else local command = "`package'"
	capture which `command'
	if _rc==111 ssc install `package'
	else ado update `package', update ssconly
}

// we install locally modified stata packages from setup_environment/code
local LOCAL_PACKAGES save_data
// save_data command originally downloaded from Gentzkow + Shapiro GitHub:
// https://github.com/gslab-econ/gslab_stata/tree/master/gslab_misc
foreach package in `LOCAL_PACKAGES' {
	// since the local changes we made extend existing stata commands,
	// we install and replace the package regardless of whether an existing
	// command already exists with the same name
	net install `package', from(`"`c(pwd)'/`package'"') replace
}

// install binsreg package from github
net install binsreg, from(https://raw.githubusercontent.com/nppackages/binsreg/master/stata) replace

capture rm ../output/stata_packages.txt
foreach package in `PACKAGES' {
	if "`package'" == "lassopack" local command = "lasso2"
	else if "`package'" == "egenmore" local command = "egen"
	else if "`package'" == "blindschemes" local command = "scheme-plotplain.scheme"
	else local command = "`package'"
	// Save output of `which` command
	log using "../temp/temp_log_`package'.log", replace
	which `command'
	log close
	shell cat <(echo `package':) <(grep '^\*! ' ../temp/temp_log_`package'.log | sed 's/^\*! / /') <(echo) >> ../output/stata_packages.txt
}
file open myfile using "../output/stata_packages.txt", write append
file write myfile "Installed: `LOCAL_PACKAGES'"
file close myfile

maptile_install using "http://files.michaelstepner.com/geo_cbsa2013.zip"
maptile_install using "http://files.michaelstepner.com/geo_county2014.zip"
maptile_install using "http://files.michaelstepner.com/geo_hrr.zip"