#!/bin/sh

test -d $PWD/bitcoin \
  || for net in testnet signet regtest
     do test "${PWD##*/}" = "$net" && { D="$PWD/.."; O="--$net"; break; }
     done

exec timeout 600 lightning-cli "--lightning-dir=${D:-$PWD}" $O "$@"
