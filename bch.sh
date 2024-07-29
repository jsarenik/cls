#!/bin/sh

#rpc decoderawtransaction drt
#rpc signrawtransactionwithwallet srt
#rpc sendrawtransaction sert
#rpc loadwallet lw
#rpc getbalances gebas
#rpc getblockcount gbc

test -d "$1" && { cd "$1"; shift; }
test -d .bitcoin && cd .bitcoin
ls | grep -q . || exit 1

# Handling of inside-the-wallet-dir cases
test -r wallet.dat && {
  mypwd=$PWD
  cd ..
  echo $mypwd | grep -qw wosh || {
    test -L $mypwd && mypwd=$(readlink $mypwd)
    wn=${mypwd##$PWD/}
    w="-rpcwallet=${wn}"
    test "$1" = "loadwallet" && add="$wn"
  }
}
test "${PWD##*/}" = "wallets" && cd ..

test -L $PWD && {
  mypwd=$(readlink $PWD)
  #echo $mypwd | grep -q "^/" || cd ..
  test "${mypwd%${mypwd#/}}" = "/" || cd ..
  cd $mypwd
}

cmd=bitcoin-cli

# main signet testnet3 testnet4 regtest liquidv1 liquidtestnet liquidregtest
c="${PWD##*/}"; chain=${c%net3}

test "${chain}" = "signet" && PATH=$HOME/bin/bitcoin-27.0-inq/bin:$PATH
test "${chain}" = "testnet4" && PATH=$HOME/bin/bitcoin-testnet4/bin:$PATH
test "${chain%${chain#liquid}}" = "liquid" && cmd=elements-cli
ddir=${PWD%/*}
test "$chain" = ".bitcoin" && { ddir=$PWD; chain=""; }

test "$1" = "-k" && exec pkill -f "$cmd -datadir=${ddir:-$PWD}"
test "$1" = "-g" && exec pgrep -f "$cmd -datadir=${ddir:-$PWD}"

exec $cmd -datadir=${ddir:-$PWD} -chain=${chain:-main} $w "$@" $add
