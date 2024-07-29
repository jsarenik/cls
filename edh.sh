#!/bin/sh

test -d "$1" && { cd "$1"; shift; }
test "$PWD" = "$HOME" && cd ~/.elements/liquidv1
export MALLOC_ARENA_MAX=1

test -L $PWD && {
  mypwd=$(readlink $PWD)
  #echo $mypwd | grep -q "^/" || cd ..
  test "${mypwd%${mypwd#/}}" = "/" || cd ..
  cd $mypwd
}

chain="${PWD##*/}"
test "${PWD##*/}" = "elementsregtest" && chain=elementsregtest
test "${PWD##*/}" = "liquidv1" && chain=liquidv1
test "${PWD##*/}" = "liquidtestnet" && chain=liquidtestnet
test "${PWD##*/}" = "liquidtestnet4" && chain=liquidtestnet4
test "$chain" = "" || { ddir=${PWD%/*}; chain="-chain=$chain"; }

exec elementsd "-datadir=${ddir:-$PWD}" ${chain} "$@"
