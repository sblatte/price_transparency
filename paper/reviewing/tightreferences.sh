#!/bin/sh

#Substitute ~\ref for \ref for words ending in [ens] like Figures, Table, Section, Definition, Panel
cd ../sections
for file in *.tex
do
	sed -i.bu 's/\([elns]\)\ \\ref{/\1~\\ref{/g' $file && rm $file.bu
done

#Substitute ~\subref for \subref
for file in *.tex
do
	sed -i.bu 's/\([Pp]anel\) \\subref{/\1~\\subref{/g' $file && rm $file.bu
done

#Substitute ~\eqref for \eqref for words endign in [ns] like equation and condition
for file in *.tex
do
	sed -i.bu 's/\([ns]\) \\eqref{/\1~\\eqref{/g' $file && rm $file.bu
done

#Substitute "column~1" for "column 1"
for file in *.tex
do
	sed -i.bu 's/olumn \([0-9]\)/olumn~\1/g' $file && rm $file.bu
done
