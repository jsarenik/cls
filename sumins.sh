#!/bin/sh
#
# <hex>

#  | sed 's/ /  /g' \
tx=${1:-$tx}
#echo $tx

grt.sh $tx | nd-ins.sh \
  | cut -d" " -f1-2 \
  | while read a b line; do echo "$a  $b" | ce.sh; done \
  | while read vout txid rest
do
#  echo $txid $((0x$vout))
  gto.sh $txid $((0x$vout)) | grep -we value | tr -d , | cut -d: -f2-
done \
  | awk '{sum+=$1} END {printf("%.8f\n", sum)}'
#  | ash -s \
