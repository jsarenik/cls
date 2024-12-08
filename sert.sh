#!/bin/sh

test "$1" = "-q" && { add="2>/dev/null"; shift; }
{ test "$1" = "" && cat || echo $1; } \
| while read line; do
{
echo $line
echo 0
} | eval bch.sh -stdin sendrawtransaction $add &
done
