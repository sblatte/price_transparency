#!/bin/bash
file ../../*/output/* | grep CRLF  #List files that have Windows line endings
file ../../*/readme.md | grep CRLF  #List files that have Windows line endings
file ../../*/code/* | grep CRLF  #List files that have Windows line endings
