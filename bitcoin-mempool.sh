#!/bin/busybox ash
#
# bitcoin-mempool.sh <address>

export LC_ALL=C
RCFILE=$HOME/.bitcoinrc
test -r $RCFILE && . $RCFILE
# set environment variable USER=user:pass there

test "$#" -gt 1 -o x"$1" = x"-h" && { echo "Usage: ${0##*/} <node>"; exit 1; }
node=${1:-"192.168.1.118:8332"}

echo '{'
echo '''{"jsonrpc":"1.0","id":"'$$'","method":"getmempoolinfo","params":[]}''' \
  | curl -s --user "$USER" \
      --data-binary @- -H 'content-type: text/plain;' $node \
  | busybox sed 's/^.*{//;s/}.*$//;s/:/: /g;s/,/,\n/g' \
  | while read line; do echo "  $line"; done
echo '}'
