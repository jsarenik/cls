#!/bin/sh

test -d "$1" && { cd "$1"; shift; }

for net in bitcoin testnet signet regtest
do test "${PWD##*/}" = "$net" && {
   exec lightningd "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
}
done

exit 1
