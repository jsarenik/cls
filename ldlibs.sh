#!/bin/sh

test "$1" = "" || cd "$1"
ldd * | grep "=>" | awk '{ print $3 }' | sort -u
