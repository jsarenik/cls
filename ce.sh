#!/bin/busybox sh
#
# Change endianess

{ test -n "$1" && echo "$@" || cat; } | fold -w2 | tac | tr -d "\n"
echo
