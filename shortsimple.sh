#!/bin/sh

BH=${1:-$(bch.sh getbestblockhash)}
last=$(echo $BH | cut -b61-64)
a=$(echo $BH | cut -b-60 | fold -w 4 | grep -Ev '^(0000|[1-9a-f]{4})$')
R=$(echo $a $last | cut -b-20)
{ echo $R | grep "$last$" || echo $R M; } | tr "0\n" ". "
echo
