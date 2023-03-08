#!/bin/sh

lock=$PREFIX/tmp/${0##*/}-$(echo ${PWD} | md5sum | cut -b-8)
test "$1" = "-c" && { rm -rf $lock; exit; }
mkdir $lock >/dev/null 2>&1 || exit 1

echo Rebroadcasting transactions from the mempool...
{ bch.sh getrawmempool \
  | tr -d '[], "' | sed '/^$/d' \
  | xargs -r -n1 bch.sh getrawtransaction \
  | bch.sh -stdin sendrawtransaction 50; } >/dev/null 2>&1
echo Rebroadcast done
rmdir $lock
