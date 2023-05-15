#!/bin/sh

tmp=$(mktemp)
cat > $tmp
chmod a+r $tmp
mv $tmp $1
cat $1
