use "../input/trimmed_provider_data_2013.dta", clear
gen year = 2013
forval year = 2014/2022 {
	append using "../input/trimmed_provider_data_`year'.dta", force
	replace year = `year' if mi(year)
}

keep if Place_Of_Srvc == "O"
merge m:1 year using "../input/CPI-U.dta", assert(match) nogen keepusing(cpiu_adj)
foreach var of varlist Avg_Mdcr_Stdzd_Amt Avg_Mdcr_Alowd_Amt Avg_Sbmtd_Chrg {
	replace `var' = `var'/cpiu_adj * 100
}
gcollapse (mean) Avg_Mdcr_Stdzd_Amt Avg_Mdcr_Alowd_Amt Avg_Sbmtd_Chrg (rawsum) Tot_Srvcs [aweight=Tot_Srvcs], by(HCPCS_Cd year Rndrng_Prvdr_Zip5)
rename Rndrng_Prvdr_Zip5 office_zcta


merge m:1 office_zcta using "../output/hospital_closures_openings.dta", assert(master match) keep(match)
gen group = "Control"
replace group = "Closure" if closure
replace group = "Opening" if opening
bysort HCPCS_Cd: egen count_codes = count(HCPCS_Cd)
gsort -count_codes
sum count_codes
keep if HCPCS_Cd == "81002"
gen standard_change = year - change if change != 0
gcollapse (mean) Avg_Sbmtd_Chrg Avg_Mdcr_Alowd_Amt [aweight=Tot_Srvcs], by(group standard_change) 
sort standard_change
keep if inrange(standard_change, -6, 6)
twoway (connected Avg_Sbmtd_Chrg standard_change if group == "Closure")  (connected Avg_Sbmtd_Chrg standard_change if group == "Opening"), legend(order(1 "Closure" 2 "Opening"))

twoway (connected Avg_Mdcr_Alowd_Amt standard_change if group == "Closure")  (connected Avg_Mdcr_Alowd_Amt standard_change if group == "Opening"), legend(order(1 "Closure" 2 "Opening"))
