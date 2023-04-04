#!/bin/sh

test -d .bitcoin && cd .bitcoin
test -d "$1" && { cd "$1"; shift; }

# Handling of inside-the-wallet-dir cases
test -r wallet.dat -o -r wosh.cat && {
  mypwd=$PWD
  echo $PWD | grep -q '/wallets' \
    && until test "${PWD##*/}" = "wallets"; do cd ..; done
  wn=${mypwd##$PWD/}
  w="-rpcwallet=${wn}"
  test "$1" = "loadwallet" && add="$wn"
  cd ..
}

test "${PWD##*/}" = "signet" && chain=signet
test "${PWD##*/}" = "testnet3" && chain=test
test "${PWD##*/}" = "regtest" && chain=regtest
test "$chain" = "" || ddir=${PWD%/*}

exec bitcoin-cli $w -datadir=${ddir:-$PWD} -chain=${chain:-main} "$@" $add
