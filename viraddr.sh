#!/bin/sh
#
# Virgin address

test "$1" = "" && read -r addr || { addr="$1"; shift; }
net="$(hnet.sh)/"
test "$net" = "main/" && net=""
tmp=$(mktemp)

curl -sSL "https://mempool.space/${net}api/address/$addr" \
  | safecat.sh $tmp

grep -q '"chain_stats":{"funded_txo_count":0' $tmp \
  && grep -q '"mempool_stats":{"funded_txo_count":0' $tmp
ret=$?
rm -f $tmp
exit $ret
