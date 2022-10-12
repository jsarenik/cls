#!/bin/sh

test "$1" = "-V" && {
  VER=1.0.1
  echo ${0##*/}-$VER-$(sed 1d $0 | md5sum | cut -b-5)
  exit
}

test -d "$1" && { cd "$1"; shift; }

bch.sh listwallets | tr -d '\[\]\n' | grep -q . || {
  bch.sh -named createwallet \
    wallet_name=default descriptors=true load_on_startup=true
}
bch.sh generatetoaddress ${1:-1} $(bch.sh getnewaddress "" bech32m)
