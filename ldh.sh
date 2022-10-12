#!/bin/sh

test "$1" = "-V" && {
  VER=1.0.1
  echo ${0##*/}-$VER-$(sed 1d $0 | md5sum | cut -b-5)
  exit
}

test -d "$1" && { cd "$1"; shift; }

for net in bitcoin testnet signet regtest
do test "${PWD##*/}" = "$net" && {
   exec lightningd "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
}
done

exit 1
