#!/bin/sh
# This is txcat.sh, a simple script that
# prints a bare raw transaction on line
sed -E 's/#[^ ]+//g' $1 | tr -cd '[0-9a-f]' | grep .
