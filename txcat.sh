#!/bin/sh
# This is txcat.sh, a simple script that
# prints a bare raw transaction on line
grep -v '^#' $1 | tr -cd '[0-9a-f]' | grep .
