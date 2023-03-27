#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

test "${PWD##*/}" = "signet" && chain=-t
test "${PWD##*/}" = "testnet3" && chain=-t
test "${PWD##*/}" = "regtest" && chain=-r

exec bitcointool ${chain} "$@"
