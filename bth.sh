#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

echo $PWD | grep -q wosh- && cd ..
test "${PWD##*/}" = "wallets" && cd ..

test "${PWD##*/}" = "signet" && chain=-t
test "${PWD##*/}" = "testnet3" && chain=-t
test "${PWD##*/}" = "regtest" && chain=-r

exec bitcointool ${chain} "$@"
