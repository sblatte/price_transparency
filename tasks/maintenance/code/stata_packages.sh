#Script to detect use of Stata commands that require packages. Not exhaustive.
echo 'reghdfe'
grep -l 'reghdfe'  ../../*/code/*.do
echo 'ppmlhdfe'
grep -l 'ppmlhdfe' ../../*/code/*.do
echo 'distinct'
grep -l 'distinct' ../../*/code/*.do
