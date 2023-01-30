#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

test -d bitcoin && cd bitcoin

test "${PWD##*/}" = "bitcoin" && net=bitcoin
test "${PWD##*/}" = "testnet" && net=testnet
test "${PWD##*/}" = "signet" && net=signet
test "${PWD##*/}" = "regtest" && net=regtest

exec timeout 600 \
  lightning-cli "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
