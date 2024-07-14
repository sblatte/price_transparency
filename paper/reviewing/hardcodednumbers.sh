#!/bin/bash
#This script allow you to review hardcoded numbers appearing in the manuscript

for file in $(find ../sections -name '*.tex')
do
	echo '===' ${file} '==='
	cat ${file} |
	awk 'BEGIN { del=0 } /\\begin{equation/ { del=1 } del<=0 { print } /\\end{equation/ { del -= 1 }' | #Drop equation environments
	awk 'BEGIN { del=0 } /\\begin{align/ { del=1 } del<=0 { print } /\\end{align/ { del -= 1 }' | #Drop align environments
	sed 's/\\input{.*}//g' | #Drop input files that might contain numbers
        sed 's/\$.*\$//g' |  #Drop inline equations
	grep -v 'includegraphics' | #Drop lines that are graphics filepaths or numbers setting the figure size
	grep -v '^%' | #Drop comments
	sed 's/[0-9\.]*\\textwidth//g' | sed 's/[0-9\.]*\\linewidth//g' |
	sed 's/label{.*}//g' | sed 's/ref{.*}//g' | #Drop labels and references
	sed 's/[Cc]olumns.[0-9] and.[0-9]//g' | sed 's/[Cc]olumns.[0-9], [0-9], and [0-9]//g' | sed 's/[Cc]olumns.[0-9]\-\-[0-9]//g' | sed 's/[Cc]olumn[s]*.[0-9]//g' |  #Drop column numbers
        sed 's/\\frac{.*}{.*}//g' |  #Drop fractions
        sed 's/\\left.*\\right//g' | #Drop between left and right brackets (equations)
	sed "s/'//" | #Drop single-quote marks that cause trouble
	sed 's/\\cite{.*}//g' | #Drop citations with \cite{} that may contain numbers
	sed 's/\\citealt{.*}//g' |  #Drop citations with \citealt{} that may contain numbers
	sed 's/\\cite[pt]\[.*]*\]{.*}//g' |  #Drop citations with \citep{} or \citet{} that may contain numbers
	sed 's/\\cite[pt]{.*}//g' |  #Drop citations with \citep{} or \citet{} that may contain numbers
	sed 's/[1-2][0-9][0-9][0-9]--[0-9]*//g' | sed 's/ 1[8-9][0-9][0-9]//g' | sed 's/ 20[0-2][0-9]//g' | #Drop years
        sed 's/[0-9][0-9]th century//g' | #Drop centuries
	sed 's/[hv]space{[0-9\.\-]*//g' | #Drop space adjustments
	sed 's/2SLS/TSLS/g' | #Substitute out 2SLS
        sed 's/9[0-9]*\\% confidence interval//g' | #Drop confidence intervals
        sed 's/[_^][0-9]//g' | sed 's/[_^]{.*}//g' | #Drop subscripts and exponents
        sed 's/[0-9]-digit//g' | sed 's/[0-9]*-cell//g' | #Drop X-digit, X-cell
        sed 's/[Rr]egion [0-9]//g' |#Drop region numbers
	grep '[0-9]'
done
