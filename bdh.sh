#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

for net in signet regtest testnet3
do
  test "${PWD##*/}" = "$net" && {
    exec bitcoind "-datadir=${PWD%/*}" "-chain=${net%net3}" "$@"
  }
done

exec bitcoind "-datadir=$PWD" -chain=main "$@"
