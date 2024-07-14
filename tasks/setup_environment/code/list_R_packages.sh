!/bin/bash

#List R package requirements based on parsing R scripts
echo 'R packages and accompanying tasks'
grep 'library' ../../*/code/*.R | sed 's/\/code\/[A-Za-z0-9_]*\.R:library(/: /' | sed 's/\.\.\/\.\.\///' | sed 's/)$//' | awk -F: '{print $2 ": " $1}' | sort | uniq
echo 'R packages used by scripts:'
grep --no-filename 'library' ../../*/code/*.R | sed 's/library(\([A-Za-z0-9\.]*\))/\1/' | sort | uniq
