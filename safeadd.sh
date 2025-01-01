#!/bin/sh

tmp=$(mktemp)
cat > $tmp
chmod a+r $tmp
test -s $tmp && { touch $1; cat $1 $tmp | safecat.sh $1; }
rm -f $tmp
