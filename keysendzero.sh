#!/bin/sh

lch.sh -k keysend \
  destination=$1 \
  amount_msat=$2 \
  maxfeepercent=0 \
  exemptfee=0msat
