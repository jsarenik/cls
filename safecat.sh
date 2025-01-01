#!/bin/sh

tmp=$(mktemp)
cat > $tmp
chmod a+r $tmp
test -s $tmp && cp -uf $tmp $1
rm -f $tmp
