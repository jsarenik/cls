#!/bin/sh

bch.sh echo here 2>/dev/null | grep -q . || cd

{ test "$1" = "" && cat || echo $@ | tr " " "\n"; } \
| while read tx
do
  #curl -sSL "https://mempool.space/api/tx/$tx/hex" | grep .
  bch.sh getrawtransaction "$tx"
done
