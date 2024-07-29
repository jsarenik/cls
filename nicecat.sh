#!/bin/sh

tmp=$(mktemp)
cat | tee $tmp
chmod a+r $tmp
test -s $tmp && mv -f $tmp $1 || rm -f $tmp
