#!/bin/bash
#test if a number in the first column of mem-layout.dat appears twice!
awk -F '[ \t]' 'FNR==NR {if($1 in a) a[$1]=a[$1]+1; else a[$1]=1;next} ($1 in a && a[$1]>1){print $1}' mem-layout.dat mem-layout.dat
