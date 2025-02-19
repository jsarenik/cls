#!/bin/sh

. /dev/shm/UpdateTip-bitcoin
if
  test "$1" = "-b"
then
  #BC=$(bch.sh getblockcount)
  BC=$height
  #BH=$(bch.sh getblockhash $BC)
  BH=$best
  printf "%s ak: " "$BC"
else
  #BH=${1:-$(bch.sh getbestblockhash)}
  BH=${1:-$best}
fi

nz=$(echo $BH | fold -w 4 | grep -cE '^[^0]{4}$')
z=$(echo $BH | fold -w 4 | grep -c '^0000$')
nzzs=$(((${nz}<<4)+${z}))
all=$(echo $BH | fold -w 4 \
    | sed 's/^/0x/' \
    | paste -s | tr '\t' ^)
printf "%04x %02x\n" \
    $(($all)) $nzzs \
    | tr 0 .
