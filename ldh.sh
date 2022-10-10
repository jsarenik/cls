#!/bin/sh

for net in bitcoin testnet signet regtest
do test "${PWD##*/}" = "$net" && {
   exec lightningd "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
}
done

exit 1
