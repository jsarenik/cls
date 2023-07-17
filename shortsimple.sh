#!/bin/sh

BH=${1:-$(bch.sh getbestblockhash)}
last=$(echo $BH | cut -b61-64)
a=$(echo $BH | fold -w 4 | grep -Ev '^(0000|[1-9a-f]{4})$' | tr "0\n" ". ")
R=$(echo $a $last | cut -b-20 )
echo $R | grep "$last " || echo $R M
