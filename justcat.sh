#!/bin/sh

tmp=$(mktemp)
cat > $tmp
chmod a+r $tmp
cat $tmp && rm $tmp
