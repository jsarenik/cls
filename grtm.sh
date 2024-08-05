#!/bin/sh

{ test "$1" = "" && cat || echo $1; } \
| while read tx
do
curl -sSL "https://mempool.space/api/tx/$tx/hex"
echo
done
exit

test "$1" = "-h" && {
  echo "Usage: ${0##*/} <height> <txid>"
  exit 1
}

PATH=$HOME/bin/bitcoin/bin:$HOME/bin/elements/bin:$PATH
export CACHE=/dev/shm/pegin
mkdir -p $CACHE

bcli() {
  bitcoin-cli "$@"
}

ecli() {
  elements-cli "$@"
}

cacheget() (
  txid=$1
  type=$2
  f=$CACHE/$txid
  test -r $f && cat $f || {
    wget -qO - https://mempool.space/api/tx/$txid \
      | tee $f
  }
#wget -qO - https://mempool.space/api/tx/$txid/hex | paste -s
#wget -qO - https://mempool.space/api/tx/$txid/merkleblock-proof | paste -s
)

TXID=${1:-5a8cf1aacffb46eca203fc551ac0e5923c1e17e432519981e9c62b2625cf5c8b}
#bcli getrawtransaction $TXID 0 2>/dev/null \
#        grep . || 
cacheget $TXID
