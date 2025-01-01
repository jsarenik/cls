#!/bin/sh

test -d "$1" && { cd "$1"; shift; }
test -d .bitcoin && cd .bitcoin
export MALLOC_ARENA_MAX=1

mypwd=$PWD
test -L $mypwd && mypwd=$(readlink $mypwd)
echo $mypwd | grep -q "^/" || mypwd="../$mypwd"
cd $mypwd

test "${PWD##*/}" = "signet" && chain=signet
test "${PWD##*/}" = "testnet3" && chain=test
test "${PWD##*/}" = "testnet4" && chain=testnet4
test "${PWD##*/}" = "regtest" && chain=regtest
test "$chain" = "" || ddir=${PWD%/*}

exec bitcoind "-datadir=${ddir:-$PWD}" -chain=${chain:-main} "$@"
