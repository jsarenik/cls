#!/bin/sh

test "$#" = 0 && { echo "Usage: $0 <bolt11> [amount] [desc]"; exit 1; }
ADD="bolt11=$1"

# For convenience, bolt11 may be supplied also as a second
# parameter. Amount is then considered to be the first.
test "$#" = "2" && {
  test "${1%${1#lnbc}}" = "lnbc" && ADD="bolt11=$1 msatoshi=$2"
  test "${2%${2#lnbc}}" = "lnbc" && ADD="bolt11=$2 msatoshi=$1"
  shift
}
shift

# In case we want to set description, let it be the third parameter.
test "$1" = "" || ADD="$ADD description=\"$1\""

lch.sh -k pay \
  maxfeepercent=0 \
  exemptfee=10msat \
  $ADD
