#!/bin/sh

export LC_ALL=C
RCFILE=$HOME/.bitcoinrc
test -r $RCFILE && . $RCFILE
# set environment variable USER=user:pass there

TMPL=/tmp/mempool$$
trap "rm -rfv $TMPL*; exit 1" EXIT INT QUIT

printf "Preparing current mempool txid snapshot... "
bch.sh getrawmempool \
  | sed '/^\[/d;/^\]/d;s/,$//;s/^  //;s/^"//;s/"$//' \
  | split -l 256 -a 5 - $TMPL \
  && echo done

ls $TMPL* >/dev/null 2>&1 \
  || { echo "Mempool empty. Sleeping."; sleep 60; exec $0; }

printf "Broadcasting: "
for file in $TMPL*; do
{ printf '['
  cat $file | while read tx
  do
    test -n "$tx" || continue
    RAW=$(bch.sh getrawtransaction $tx 2>/dev/null) || continue
    printf '{"jsonrpc": "1.0", "id": "send", "method": "sendrawtransaction", "params": ["%s"]},' $RAW
  done
  printf '{"jsonrpc": "1.0", "id": "getbc", "method": "getblockcount", "params": []}]\n'
} | curl -s --user $USER --data-binary @- -H 'content-type: text/plain;' \
    http://127.0.0.1:${1:-8332}/ >/dev/null \
  && { rm $file && printf .; } \
  || { echo "ERR $file"; exit 1; }
done
echo done
sleep 20
exec $0
