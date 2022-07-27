#!/bin/sh

DESC="Thank you!"
test "$3" = "" || DESC="$3"
exec lch.sh -k invoice \
  label=$2-$RANDOM \
  description=$DESC \
  exposeprivatechannels="728591x176x1" \
  amount_msat=$1

#  exposeprivatechannels="true" \
