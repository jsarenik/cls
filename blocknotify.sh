#!/bin/sh
#
# The $PREFIX is added for Termux on Android
# Usage: blocknotify.sh <blockhash>

add=$(echo ${PWD} | md5sum | cut -b-7)
lock=$PREFIX/tmp/lock-$add
blocks=$PREFIX/tmp/blocks-$add
mkdir -p $blocks

test "$1" = "-c" && { rm -rf $lock $blocks; rebroadcast.sh -c; true; exit; }
umask 033
mkdir $blocks/$1
hsh=$1
shift

myexit() {
  rmdir $lock 2>/dev/null
  true
  exit
}

printall() {
  while ls -d $blocks/* >/dev/null 2>&1; do
  for h in $blocks/*; do
    printf "%s " ${h##*/} && rmdir $h
    bch.sh getblockheader ${h##*/} 2>/dev/null \
      | tr -d ' ,"' \
      | grep ^height \
      | cut -d: -f2- \
      | grep . \
      || break
  done | sort -n -t " " -k 2 | xargs -n2 nicehash.sh
  done
}

mkdir $lock 2>/dev/null || { true; exit; }

printall

shmp=$PREFIX/dev/shm
gbci=$shmp/getblockchaininfo-$add
bch.sh getblockchaininfo | safecat.sh ${gbci}-new && {

gbc=$shmp/getblockcount-$add
gbh=$shmp/getblockhash-$add

cat $gbci | grep blocks | grep -o '[0-9]\+' | safecat.sh ${gbc}
echo $hsh | safecat.sh ${gbh}

best=$(cat $gbci | grep headers | grep -o '[0-9]\+' || echo 0)
ours=$(cat $gbci | grep blocks | grep -o '[0-9]\+' || echo 1)
test "$best" = "$ours" || myexit
}

# Per-block automation - see 777776.sh
test -r ${B}.sh && . ./${B}.sh

# If we got all the way here
# it means the block is the last known

# Sound a bell
bell.sh

# End if just testing with -t
test "$1" = "-t" && myexit

rmdir $lock

# Throw dice
throwdice.sh

# Rebroadcast once
nohup rebroadcast.sh >/dev/null 2>&1 &

true
