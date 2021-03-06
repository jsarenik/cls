#!/bin/sh

ADD="bolt11=$1"
test "$2" = "" || {
  echo $1 | grep -i ^lnbc && ADD="bolt11=$1 msatoshi=$2"
  echo $2 | grep -i ^lnbc && ADD="bolt11=$2 msatoshi=$1"
}
lch.sh -k pay \
  maxfeepercent=1 \
  exemptfee=10msat \
  $ADD
