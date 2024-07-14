## DEFINITIONS

# These second line is commented out because paper.tex lacks content at the moment:
PAPER_SECTIONS = $(shell grep -v '%.*input' paper.tex | grep -o 'sections/[A-Za-z_]*\.tex')
#PAPER_INPUTS = $(shell grep --no-filename 'input/' $(PAPER_SECTIONS) | grep -v '^%.*\\input' | grep -o 'input/[A-Za-z0-9_\.\-]*\.[a-z]*')

## RECIPES

all: paper.pdf

.INTERMEDIATE: paper.aux
paper.aux: paper.tex $(PAPER_SECTIONS) $(PAPER_INPUTS) ../bib/gottlieb.bib
	pdflatex -shell-escape -draftmode $<
	rm $(addprefix $(basename $<),.log .out)

paper.pdf: paper.tex $(PAPER_SECTIONS) $(PAPER_INPUTS) ../bib/gottlieb.bib
	if command -v sbatch > /dev/null ; then module load texlive; fi
	pdflatex -shell-escape -draftmode $(basename $<).tex
	bibtex $(basename $<).aux
	pdflatex -draftmode $(basename $<).tex
	pdflatex $(basename $<).tex
	rm $(basename $<).log $(basename $<).out
	rm $(basename $<).bbl $(basename $<).blg

.INTERMEDIATE: paper.info
paper.info: paper.pdf
	pdftk $< dump_data output $@

clean:
	rm *.aux *.log *.out
	rm *.toc *.bbl *.blg

metadata.txt sections/abstract.html: metadata.sh paper.tex sections/abstract.tex
	bash $<

# Input recipes
input/:
	mkdir $@
