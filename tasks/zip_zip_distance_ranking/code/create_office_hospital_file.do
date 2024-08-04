// Create file with characteristics of the hospitals closest to the office

assert inrange(`1', 2013, 2022)
local year = `1'
local short_year = substr("`year'", -2, .)

import delimited using "../input/MUP_INP_RY24_P04_V10_DY`short_year'.csv", clear
keep 