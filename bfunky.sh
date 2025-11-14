#!/bin/sh -c "echo source me"
# source this file or embed it in your script

setbchain() {
  test "${PWD##*/}" = "signet" && chain=signet
  test "${PWD##*/}" = "testnet3" && chain=test
  test "${PWD##*/}" = "testnet4" && chain=testnet4
  test "${PWD##*/}" = "regtest" && chain=regtest
  test "$chain" = "" || ddir=${PWD%/*}
}

# Bitcoin Daemon Here - starts a bitcoind in current directory
bdh() (
  test -d .bitcoin && cd .bitcoin
  test -d "$1" && { cd "$1"; shift; }
  setbchain
  bitcoind "-datadir=${ddir:-$PWD}" -chain=${chain:-main} "$@"
)

# Bitcoin Client Here - starts a bitcoin-cli in current directory
bch() (
  test -d .bitcoin && cd .bitcoin
  test -d "$1" && { cd "$1"; shift; }
  test -r wallet.dat && { wallet="-rpcwallet=${PWD##*/}"; cd ..; }
  echo $PWD | grep -q wosh- && test -r wosh.cat && cd ..
  test "${PWD##*/}" = "wallets" && cd ..
  setbchain
  bitcoin-cli -rpcclienttimeout=0 $wallet "-datadir=${ddir:-$PWD}" \
    -chain=${chain:-main} "$@"
)

setlnet() {
  test "${PWD##*/}" = "bitcoin" && net=bitcoin
  test "${PWD##*/}" = "testnet" && net=testnet
  test "${PWD##*/}" = "signet" && net=signet
  test "${PWD##*/}" = "regtest" && net=regtest
}

# Lightning Daemon Here - starts a lightningd in current directory
ldh() (
  test -d "$1" && { cd "$1"; shift; }
  setlnet
  lightningd "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
)

# Lightning Client Here - starts a lightning-cli in current directory
lch() (
  test -d "$1" && { cd "$1"; shift; }
  test -d bitcoin && cd bitcoin
  setlnet
  lightning-cli "--lightning-dir=${PWD%/*}" "--network=$net" "$@"
)

# Bitcoin Tool Here - starts bitcointool with network parameter
bth() (
  test -d "$1" && { cd "$1"; shift; }
  test "${PWD##*/}" = "signet" && chain=-t
  test "${PWD##*/}" = "testnet3" && chain=-t
  test "${PWD##*/}" = "testnet4" && chain=-t
  test "${PWD##*/}" = "regtest" && chain=-r
  bitcointool ${chain} "$@"
)
