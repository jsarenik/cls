#!/bin/sh
#
# bitcoin-send.sh <address>

test "$1" = "" && { echo "Usage: ${0##*/} <address>"; exit 1; }
address=$1; shift

amount=$(bcw.sh getbalance)
printf "Would you like to send %s to %s? [y/N]: " ${amount} ${address}
read answer
test "$answer" = "y" || exit 1

bch.sh "$@" -named sendtoaddress \
  amount=${amount} \
  address=${address} \
  subtractfeefromamount=true \
  replaceable=false \
  avoid_reuse=false \
  fee_rate=1
