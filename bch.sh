#!/bin/sh

for net in signet regtest testnet3
do
  test "${PWD##*/}" = "$net" && {
    exec bitcoin-cli "-datadir=${PWD%/*}" "-chain=${net%net3}" "$@"
  }
done

exec bitcoin-cli "-datadir=$PWD" -chain=main "$@"
