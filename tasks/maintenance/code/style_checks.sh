
echo No script other than a Makefile should contain ../../ in a filepath. List of violaters:
grep -l '\.\.\/\.\.\/' ../../*/code/*.* | grep 'do\|jl\|py\|R'

#Stata scripts should use assert() and keepusing() when merging
echo "How many Stata scripts contain a merge that has neither assert() nor keepusing()?"
grep 'merge [m1]:' ../../*/code/*.do | grep -v 'assert(' | grep -v 'keepusing(' | grep -o '^.*\.do:' | sort | uniq | wc -l
echo List of troublesome scripts with most violations:
grep 'merge [m1]:' ../../*/code/*.do | grep -v 'assert(' | grep -v 'keepusing(' | grep -o '^.*\.do' | sort | uniq -c | sort -nr | head

#Stata scripts should use save_data rather than save
echo "How many Stata scripts contain the save command for a permanent file?"
grep 'save ' ../../*/code/*.do | grep -v 'save `' | grep -v 'graph save' | grep -v '\.do://' | grep -v '//save' | wc -l
echo List of troublesome scripts:
grep 'save ' ../../*/code/*.do | grep -v 'save `' | grep -v 'graph save' | grep -v '\.do://' | grep -v '//save' | grep -o '^.*\.do' | sort | uniq
echo List of troublesome scripts with violation shown:
grep 'save ' ../../*/code/*.do | grep -v 'save `' | grep -v 'graph save' | grep -v '\.do://' | grep -v '//save'

#Makefiles should contain SHELL=bash
echo "How many Makefiles do not contain SHELL=bash?"
grep --files-without-match 'SHELL=bash' ../../*/code/Makefile | sort | uniq | wc -l
echo "List of troublesome Makefiles:"
grep --files-without-match 'SHELL=bash' ../../*/code/Makefile | sort | uniq

#Makefiles should use ln -sf rather than ln -s
echo "How many Makefiles contain ln -s rather than ln -sf?"
grep 'ln -s ' ../../*/code/Makefile | sort | uniq | wc -l
echo "List of troublesome Makefiles:"
grep 'ln -s ' ../../*/code/Makefile | grep -o '^.*Makefile' | sort | uniq
