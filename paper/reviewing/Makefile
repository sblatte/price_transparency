SHELL=/bin/bash

all: repeatedwords duplicatelabels labelsreferenced acronyms_usedanddefined tightreferences hardcodednumbers chktex textidote checkURLs

.PHONY: repeatedwords duplicatelabels labelsreferenced acronyms_usedanddefined tightreferences hardcodednumbers chktex textidote

repeatedwords:
	egrep "(\b[a-zA-Z]+) \1\b" ../sections/*.tex -n

labelsreferenced:
	diff --side-by-side --suppress-common-lines <(grep -o --no-filename 'ref{[A-Za-z0-9:_\-]*}' ../sections/*.tex | sed 's/ref//' | sort | uniq) <(grep -o --no-filename 'label{[A-Za-z0-9:_\-]*}' ../sections/*.tex | sed 's/label//' | sort | uniq)

duplicatelabels:
	grep -oh 'label{[A-Za-z0-9:_]*}' ../sections/*.tex | sort | uniq -c | grep -v ' 1 label'

acronyms_usedanddefined:
	diff --side-by-side --suppress-common-lines  <(grep -o --no-filename -E ' \(+[A-Z]+[A-Z]+[s]*\)' ../sections/*.tex | sort | sed 's/[()]//g' | sed 's/ //g' | sed 's/s$$//' | uniq) <(grep --no-filename -v '^%' ../sections/*.tex | grep -o -E '[[:space:]][A-Z]+[A-Z]+[s]*[ .]' | sed 's/[[:space:]]//g' | sed 's/\.$$//' | sed 's/s$$//' | sort | uniq)

tightreferences: tightreferences.sh
	bash tightreferences.sh

hardcodednumbers: hardcodednumbers.sh
	bash hardcodednumbers.sh

chktex: ../paper.tex 
	cd .. && chktex paper.tex --nowarn 2 --nowarn 3 --nowarn 24

textidote: /Applications/textidote.jar ../reviewing/textidote_dico.txt ../paper.tex 
	java -jar /Applications/textidote.jar --check en --dict ../reviewing/textidote_dico.txt ../paper.tex 

topicsentences.pdf: topicsentences.tex
	pdflatex $<
	rm $(addprefix $(basename $<),.aux .log .out)

.INTERMEDIATE: topicsentences.tex
PAPER_SECTIONS = $(shell grep input ../paper.tex | grep -v '^%' | grep -o 'sections/[a-zA-Z0-9_]*\.tex')
topicsentences.tex: ../paper.tex
	sed -n '1,/begin{document}/p' ../paper.tex > $@
	for file in $(PAPER_SECTIONS); do grep $${file} ../paper.tex | grep -o '^.*\\input' | sed 's/\\input//' >> $@; grep -v '^%' ../$${file} | sed '/begin{figure}/,/end{figure}/d' | sed '/begin{table}/,/end{table}/d' | sed '/begin{align.}/,/end{align.}/d' | sed 's/^\\label{[A-za-z0-9:]*}$$//' | sed -E -n '/^$$/,/\.|\?/p' >> $@ ; done
	echo '\end{document}' >> $@

URL_LIST:= $(shell grep -o 'href{[A-Za-z0-9:/\._?=]*}' ../sections/*.tex | sed 's/.*href{//' | sed 's/}//' )
checkURLs:
	for URL in $(URL_LIST) ; do wget --spider --no-verbose $${URL} ; done

availablegreeks: greekletters.tex
	diff --side-by-side --suppress-common-lines <(grep -o --no-filename '\\[A-Za-z][a-z]*' ../paper.tex ../sections/*.tex | sort | uniq) <(sort greekletters.tex) | grep -v '<' | sed 's/^.*[|>]//'

dueto_list:  #Did you mean "because of", "owing to", or "from"?
	grep -n 'due to' ../sections/*.tex
