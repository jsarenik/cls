#!/bin/sh

for net in testnet3 signet regtest
do
  test -d $net && break
  test "${PWD##*/}" = "$net" && { D="$PWD/.."; O="-${net%3}"; break; }
done

exec bitcoin-cli "-datadir=${D:-$PWD}" $O "$@"
