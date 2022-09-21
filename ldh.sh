#!/bin/sh

test -d $PWD/bitcoin \
  || for net in testnet signet regtest
     do test "${PWD##*/}" = "$net" && { D="$PWD/.."; O="--network $net"; break; }
     done

exec lightningd "--lightning-dir=${D:-$PWD}" $O "$@"
