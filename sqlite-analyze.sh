#!/bin/sh

DF=${1:-"/tmp/lightningd.sqlite3"}

sqlite3 $DF .dump \
  | grep -o '^INSERT INTO [a-z_]\+' \
  | uniq -c
