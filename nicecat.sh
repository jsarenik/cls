#!/bin/sh

tmp=$(mktemp /tmp/tmp-nicecat.XXXXXX)
cat | tee $tmp
chmod a+r $tmp
cp -u $tmp $1
rm -f $tmp
