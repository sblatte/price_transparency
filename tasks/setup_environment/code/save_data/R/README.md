
# Overview

The SaveData package provides a function to save and summarize data. 
The package is adapted from the `SaveData` package by Gentzkow and Shapiro (2020) with modifications (listed below).


## SaveData
Use `SaveData()` to save to standard formats and create a log file that summarizes the saved data. 
The log file presents the first and last two observations, 
gives standard summary statistics for numerical variables, and displays variable types for all variables.

## Modifications to the original package by Gentzkow & Shapiro
1. Report the first and last two observations of the dataset.
2. Allow for missing observations in key variables.
3. Use `kable` to print summary statistics tables as 
`stargazer` is sometimes problematic when parsing variable names 
(e.g., `tasks/downloaddata/report/ACS_20152019_covariates_tracts.csv.log`) 
and rounding values 
(e.g., `tasks/downloaddata/report/ACS_20092013_covariates_cbsa.dta.log`).
