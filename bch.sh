#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

test -r wallet.dat && { wallet="-rpcwallet=${PWD##*/}"; cd ..; }
test "${PWD##*/}" = "wallets" && cd ..

test "${PWD##*/}" = "signet" && chain=signet
test "${PWD##*/}" = "testnet3" && chain=test
test "${PWD##*/}" = "regtest" && chain=regtest
test "$chain" = "" || ddir=${PWD%/*}

exec bitcoin-cli $wallet "-datadir=${ddir:-$PWD}" -chain=${chain:-main} "$@"
