#!/bin/sh

for net in signet regtest testnet3
do
  test "${PWD##*/}" = "$net" && {
    exec bitcoind "-datadir=${PWD%/*}" "-${net%3}" "$@"
  }
done

exec bitcoind "-datadir=$PWD" "$@"
