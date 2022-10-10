#!/bin/sh

test -d $PWD/bitcoin && cd bitcoin
for net in bitcoin testnet signet regtest
do
  test "${PWD##*/}" = "$net" && {
    exec timeout 600 \
      lightning-cli "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
  }
done

exit 1
