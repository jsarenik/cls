#!/bin/sh

test -d "$1" && { cd "$1"; shift; }
test -d .bitcoin && cd .bitcoin
export MALLOC_ARENA_MAX=1

mypwd=$PWD
test -L $mypwd && mypwd=$(readlink $mypwd)
echo $mypwd | grep -q "^/" || mypwd="../$mypwd"
cd $mypwd

test "${PWD##*/}" = "signet" && chain=signet \
  PATH=$HOME/bin/bitcoin-27.0-inq/bin:$PATH
test "${PWD##*/}" = "testnet3" && chain=test
test "${PWD##*/}" = "testnet4" && chain=testnet4 \
  PATH=$HOME/bin/bitcoin-testnet4/bin:$PATH
test "${PWD##*/}" = "regtest" && chain=regtest

test "$chain" = "" \
    || { ddir=${PWD%/*}; chain="-chain=$chain"; }

exec bitcoind "-datadir=${ddir:-$PWD}" ${chain} "$@"
