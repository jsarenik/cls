#!/bin/sh

lch.sh -k keysend \
  maxfeepercent=0 \
  exemptfee=10msat \
  destination=$1 \
  msatoshi=$2
