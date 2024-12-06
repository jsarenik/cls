#!/bin/sh

bch.sh listunspent ${1:-0} \
  | grep -w "txid\|vout\|amount" \
  | tr -d ' ,"' \
  | cut -d: -f2 \
  | paste -d " " - - -
