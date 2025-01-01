#!/bin/sh

#gbt.sh | jq -r ".transactions[] | .fee, .weight" \
gbt.sh | grep -w -e txid -e fee -e weight | tr -d ' ",' | cut -d: -f2 \
  | paste -d" " - - - \
  | awk 'BEGIN {wsum=0} {printf("%d %s %d\n",
	  wsum, $1, 4000*$2/$3); wsum+=$3}'
