#!/bin/sh

test "$1" = "-V" && {
  VER=1.0.1
  echo ${0##*/}-$VER-$(sed 1d $0 | md5sum | cut -b-5)
  exit
}

test -d "$1" && { cd "$1"; shift; }

for net in signet regtest testnet3
do
  test "${PWD##*/}" = "$net" && {
    exec bitcoind "-datadir=${PWD%/*}" "-chain=${net%net3}" "$@"
  }
done

exec bitcoind "-datadir=$PWD" -chain=main "$@"
