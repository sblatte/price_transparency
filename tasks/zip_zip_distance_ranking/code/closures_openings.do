use "../output/nearby_hospitals_2013.dta", clear
gen year = 2013

forval year = 2014/2022 {
	append using "../output/nearby_hospitals_`year'.dta"
	replace year = `year' if mi(year)
}

keep office_zcta year distance_1 zcta5_1 
reshape wide distance_1 zcta5_1, i(office_zcta) j(year)
gen change = 0
local i = 0
forval year = 2013/2022 {
	local j = `year' + 1
	forval year_plus = `j'/2022 {
		replace change = `year_plus' if zcta5_1`year' != zcta5_1`year_plus' & change == 0
	}
	
}

gen closure = 0
gen opening = 0
levelsof change, local(levels)
foreach l of local levels {
	if `l' == 0 continue
	local old = `l' - 1
	replace closure = 1 if distance_1`l' - distance_1`old' > 0 & change == `l'
	replace opening = 1 if distance_1`l' - distance_1`old' < 0 & change == `l'
}


save_data "../output/hospital_closures_openings.dta", replace log_replace key(office_zcta) 
