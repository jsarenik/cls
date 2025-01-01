#!/bin/sh

#gbt.sh | jq -r ".transactions[] | .fee, .weight" \
gbt.sh | grep -w "fee\|weight" | tr -d '[a-z] :",' \
  | paste -d" " - - \
  | awk '{fsum+=$1; wsum+=$2}
         END{printf("%d\n",
	  fsum*4000000/wsum/NR)}'
