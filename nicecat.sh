#!/bin/sh

tmp=$(mktemp)
cat | tee $tmp
chmod a+r $tmp
test -s $tmp && cp -uf $tmp $1
rm -f $tmp
