#!/bin/sh
#
# <hex>

tx=${1:-$tx}
ins=$(sumins.sh $tx)
outs=$(sumouts.sh $tx)
printf "%.8f\n" $(echo "scale=8; $ins-$outs" | bc)
