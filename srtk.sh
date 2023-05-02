#!/bin/sh

privkey=$(cat privkey) || {
  printf "Make sure the privkey is in file privkey in $PWD" >&2
  exit
}

{
cat
echo '''["'$privkey'"]'''
} | bch.sh -stdin signrawtransactionwithkey \
  | grep '"hex"' \
  | cut -d: -f2- \
  | tr -d ' ,"'
