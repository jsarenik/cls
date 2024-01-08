#!/bin/sh
#
# This script gets bitcoin.pdf from the UTXOs (also on a pruned node)
# Originally by jb55 at bitcoinhackers.org/@jb55/105595146491662406

tx=54e48e5f5c656b26c3bca14a8c95aa583d07ebe84dde3b7dd4a78f4e4186e713 
max=945
for vout in $(seq 0 $max)
do
  bitcoin-cli gettxout $tx $vout false \
    | grep 'OP_CHECKMULTISIG",$' | cut -d ' ' -f7-9
done | tr -d ' \n' | cut -c 17-368600 | xxd -r -p > bitcoin.pdf
