local outfile "../output/stata_setup.txt"

shell echo "Setup:" > `outfile'

set type float, perm
shell echo "Type permanently set to float" >> `outfile'
