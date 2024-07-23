// Calculate national price dispersion among non-facility
set scheme stcolor
forval year = 2013/2022 {
    use "../input/trimmed_provider_data_`year'.dta", clear
    rename *, lower
    keep if place_of_srvc == "O"
    gen year = `year'
    destring rndrng_prvdr_state_fips, replace force
    gen binary = (rndrng_prvdr_state_fips == 6)
    gen ratio = avg_sbmtd_chrg/avg_mdcr_alowd_amt
    gcollapse (variance) ratio avg_sbmtd_chrg avg_mdcr_alowd_amt [aweight=tot_srvcs], by(year binary)
    tempfile charge_`year'
    save `charge_`year''
}

use `charge_2013', clear
forval year = 2014/2022 {
    append using `charge_`year''
}

sort binary year
twoway (connected avg_sbmtd_chrg year if binary == 1) (connected avg_mdcr_alowd_amt year if binary == 0) (connected avg_mdcr_alowd_amt year if binary == 1) (connected avg_sbmtd_chrg year if binary == 0), legend(order(1 "CA Charge" 2 "Rest of Country Charge" 3 "CA Medicare Covered" 4 "Rest of Country Medicare Covered") pos(6) row(2)) 

graph export "../output/disperion_variance.pdf", replace
drop if year == 2018
twoway (connected ratio year if binary == 1) (connected ratio year if binary == 0), legend(order(1 "CA" 2 "Rest of Country") pos(6) row(2)) 
graph export "../output/dispersion_ratio_variance.pdf", replace
