#!/bin/sh

BH=${1:-$(bch.sh getbestblockhash)}
last=$(echo $BH | cut -b61-64)
nz=$(echo $BH | fold -w 4 | grep -E '^[^0]{4}$' | wc -l)
z=$(echo $BH | fold -w 4 | grep '^0000$' | wc -l)
printf "%s %x%x" $last ${nz} ${z} | tr "0\n" ". "
echo
