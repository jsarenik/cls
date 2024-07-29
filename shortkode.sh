#!/bin/sh

BH=${1:-$(bch.sh getbestblockhash)}
last=${BH#${BH%????}}
nz=$(echo $BH | fold -w 4 | grep -cE '^[^0]{4}$')
z=$(echo $BH | fold -w 4 | grep -c '^0000$')
printf "%s %x" $last \
  "$(((${nz} <<4) + ${z}))" \
  | tr "0\n" ". "
echo
