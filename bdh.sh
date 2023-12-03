#!/bin/sh

test -d .bitcoin && cd .bitcoin
export MALLOC_ARENA_MAX=1

test -d "$1" && { cd "$1"; shift; }

test "${PWD##*/}" = "signet" && chain=signet
test "${PWD##*/}" = "testnet3" && chain=test
test "${PWD##*/}" = "regtest" && chain=regtest
test "$chain" = "" || ddir=${PWD%/*}

exec bitcoind "-datadir=${ddir:-$PWD}" -chain=${chain:-main} "$@"
