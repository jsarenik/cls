#!/bin/sh

tmp=$(mktemp)
cat > $tmp
chmod a+r $tmp
test -s $tmp && mv -uf $tmp $1 && cat $1
