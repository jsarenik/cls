#!/bin/sh

{ test "$1" = "" && cat || echo $1; } \
| while read line; do
{
echo $line
echo 0
} | bch.sh -stdin sendrawtransaction
done
