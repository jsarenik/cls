#!/bin/sh

for net in signet regtest testnet3
do
  test "${PWD##*/}" = "$net" && {
    exec bitcoin-cli "-datadir=${PWD%/*}" "-${net%3}" "$@"
  }
done

exec bitcoin-cli "-datadir=$PWD" "$@"
