#!/bin/bash

cat $* | tr '\t' ' ' | sed 's/^ *//;s/ *$//;s/  */ /g'

#replace tabs with spaces: tr '\t' ' '
#remove spaces at beginning of line: s/^ *//
#remove spaces befor eof: s/ *$//
#replace double spaces with single spaces: s/  */ /
