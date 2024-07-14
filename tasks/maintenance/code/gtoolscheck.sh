#This script reports Stata commands that could switch to gtools equivalents
#https://gtools.readthedocs.io/en/latest/index.html
grep '^[[:space:]]*collapse\|^[[:space:]]*reshape\|^[[:space:]]*egen\|^[[:space:]]*contract\|^[[:space:]]*isid\|^[[:space:]]*levelsof\|^[[:space:]]*duplicates\|^[[:space:]]*xtile\|^[[:space:]]*tabstat\|^[[:space:]]*unique\|^[[:space:]]*distinct' ../../*/code/*.do
