#!/bin/sh

tmp=$(mktemp /tmp/tmp-safeadd.XXXXXX)
cat > $tmp
chmod a+r $tmp
cat "$1" $tmp | safecat.sh "$1"
rm -f $tmp
