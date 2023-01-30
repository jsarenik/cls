#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

test "${PWD##*/}" = "bitcoin" && net=bitcoin
test "${PWD##*/}" = "testnet" && net=testnet
test "${PWD##*/}" = "signet" && net=signet
test "${PWD##*/}" = "regtest" && net=regtest

exec lightningd "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
