#!/bin/sh

test -d .bitcoin && cd .bitcoin
test -d "$1" && { cd "$1"; shift; }

test "${PWD##*/}" = "signet" && chain=signet
test "${PWD##*/}" = "testnet3" && chain=test
test "${PWD##*/}" = "regtest" && chain=regtest
ddir=$PWD
ddir=${ddir:-$PWD%/*}

exec bitcoind "-datadir=$ddir" -chain=${chain:-main} "$@"
