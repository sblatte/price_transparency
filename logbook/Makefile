SHELL=bash

logbookentries := $(shell grep 'entries' logbook.tex | grep -v '^%' | grep -o 'entries/[A-Za-z0-9_-]*\.tex')
img_inputs := $(shell grep '\\includegraphics' $(logbookentries) | grep -v '%.*\\includegraphics' | sed 's/^.*\\includegraphics\[.*\]{\([\./a-zA-Z0-9._-]*\)}.*/\1/')
tex_inputs := $(shell grep --no-filename '\\input' $(logbookentries) | grep -v '^%' | grep -o 'input{[A-Za-z0-9_\/\.]*}'  | sed 's/input{//' | sed 's/}$$//')
#scratchentries := $(shell grep 'entries' scratch.tex | grep -v '^%' | grep -o 'entries/[A-Za-z0-9_]*\.tex')
#img_scratch_inputs := $(shell grep '\\includegraphics' $(scratchentries) | grep -v '%.*\\includegraphics' | sed 's/^.*\\includegraphics\[.*\]{\([\./a-zA-Z0-9._-]*\)}.*/\1/')
#tex_scratch_inputs := $(shell grep --no-filename '\\input' $(scratchentries) | grep -v '^%' | grep -o 'input{[A-Za-z0-9_\/\.]*}'  | sed 's/input{//' | sed 's/}$$//')
# Scratch entries commented out while there is nothing in scratch.tex, since that will cause make to get stuck

all: logbook.pdf scratch.pdf

clean:
	rm *.log *.out *.toc *.aux
	-rm *.auxlock
clean_figs:
	rm logbook-figure*.* 
	-rm scratch-figure*.* 

logbook.pdf: logbook.tex $(logbookentries) $(img_inputs) $(tex_inputs) | ../bib/gottlieb.bib
	pdflatex -shell-escape -draftmode $<
	bibtex $(basename $<).aux
	pdflatex -shell-escape -draftmode $<
	pdflatex -shell-escape $<
	rm $(addprefix $(basename $<),.log .out .toc)
	rm $(basename $<).bbl $(basename $<).blg

.INTERMEDIATE: logbook.aux
logbook.aux: logbook.tex $(logbookentries) $(img_inputs) $(tex_inputs) | ../bib/gottlieb.bib
	pdflatex -shell-escape -draftmode $<
	rm $(addprefix $(basename $<),.log .out .toc)

scratch.pdf: scratch.tex $(scratchentries) $(img_scratch_inputs) $(tex_scratch_inputs) | ../bib/gottlieb.bib
	pdflatex -shell-escape -draftmode $<
	bibtex $(basename $<).aux
	pdflatex -shell-escape -draftmode $<
	pdflatex -shell-escape $<
	rm $(addprefix $(basename $<),.log .out .aux)
	rm $(addprefix $(basename $<),.bbl .blg)

# Input recipes
input/:
	mkdir $@
