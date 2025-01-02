#!/bin/sh
#
# <hex>

tx=${1:-$tx}
#echo $tx

grt.sh $tx | nd-outs.sh \
  | cut -d" " -f1 \
  | while read a line; do echo "$a" | ce.sh; done \
  | while read amt rest
do
#  echo $amt
  echo $((0x$amt))
#  gto.sh $txid $((0x$vout)) | grep -we value | tr -d , | cut -d: -f2-
done \
  | awk '{sum+=$1} END {printf("%.8f\n", sum/100000000)}'
