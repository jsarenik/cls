#!/bin/sh

lock=/tmp/${0##*/}-$(echo ${PWD} | md5sum | cut -b-8)
mkdir $lock || exit 1

mempool=/tmp/mempool$$
trap "rm -rfv $mempool; exit" INT QUIT

printf "%s " "Preparing current mempool txid snapshot..."
bch.sh getrawmempool \
  | tr -d '[], "' | sed '/^$/d' \
  > $mempool \
  && echo done

ls $mempool >/dev/null 2>&1 \
  || { echo "Mempool empty. Exiting."; exit; }

echo Rebroadcasting transactions from the mempool...
  while read tx
  do
    test -n "$tx" || continue
    { bch.sh getrawtransaction $tx | bch.sh -stdin sendrawtransaction 50; } \
      >/dev/null 2>&1
  done < $mempool
  rm $mempool
echo Rebroadcast done
rmdir $lock
