#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

for net in signet regtest testnet3
do
  test "${PWD##*/}" = "$net" || continue
  chain=${net%net3}; ddir=${PWD%/*}
done

exec bitcoind "-datadir=${ddir:-$PWD}" -chain=${chain:-main} "$@"
