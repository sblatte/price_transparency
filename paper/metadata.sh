#!/bin/bash

echo 'Title: ' > metadata.txt
grep -o 'pdftitle={.*}' paper.tex | sed 's/pdftitle={\([A-Za-z0-9\ ]*\)}/\1/' >> metadata.txt
echo 'Author: ' >> metadata.txt
grep -o 'pdfauthor={.*}' paper.tex | sed 's/pdfauthor={\([A-Za-z0-9,\.\ ]*\)}/\1/' >> metadata.txt
echo 'Abstract: ' >> metadata.txt
pandoc sections/abstract.tex -t plain | sed 's/$/ /' | tr -d '\n' |
	sed 's/ \—\([A-Za-z]\)/ \— \1/' | sed 's/\([A-Za-z]\)\— /\1 \— /' | #deal with emdash
	cat >> metadata.txt
echo '' >> metadata.txt
grep 'Keywords' paper.tex | pandoc --wrap=none -f LaTeX -t plain >> metadata.txt
grep 'JEL' paper.tex | pandoc -f LaTeX -t plain >> metadata.txt

pandoc sections/abstract.tex -t html | sed 's/$/ /' | tr -d '\n' |
	sed 's/ \—\([A-Za-z]\)/ \— \1/' | sed 's/\([A-Za-z]\)\— /\1 \— /' | #deal with emdash
	cat >> sections/abstract.html
