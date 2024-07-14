#!/bin/bash

file ../../*/readme.md | grep CRLF  #List files that have Windows line endings


for file in $(file ../../*/readme.md | grep CRLF | grep -o '^.*:' | sed 's/:$//')
do
        mv ${file} ${file}.bak; cat ${file}.bak | tr -d '\r' > ${file}
done

file ../../*/code/* | grep CRLF  #List files that have Windows line endings

for file in $(file ../../*/code/* | grep CRLF | grep -o '^.*:' | sed 's/:$//')
do
	mv ${file} ${file}.bak; cat ${file}.bak | tr -d '\r' > ${file}
done

#file ../../*/output/* | grep CRLF  #List files that have Windows line endings
#
#for file in $(file ../../*/output/* | grep CRLF | grep -o '^.*:' | sed 's/:$//')
#do
#        mv ${file} ${file}.bak; cat ${file}.bak | tr -d '\r' > ${file}
#done


