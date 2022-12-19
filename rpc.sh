#!/bin/sh

SOCK=$HOME/.lightning/bitcoin/lightning-rpc
bolt11=$1
desc=${2:-"paying anyone"}
test "$bolt11" = "" && exit 1

{
  busybox tr -d ' \n' <<EOF
{
  "jsonrpc": "2.0",
  "method": "pay",
  "id": "lightning-rpc-$RANDOM$RANDOM",
  "params": {
    "maxfeepercent": 0,
    "exemptfee": "10msat",
    "bolt11": "$bolt11",
    "description": "[[\"text/plain\",\"$desc\"]]"
  }
}
EOF
} | /usr/bin/nc -U $SOCK \
  | busybox head -1
# | jq -r .result.bolt11
#  $amount \
#amount=$2
#"msatoshi":%d,
