#!/bin/sh

bh_url=https://be.anyone.eu.org/api/block

myget() {
  wget -qO - "$@"
}

input=$1

echo $input | grep -q 'x' || {
txid=$input
tx_url=https://be.anyone.eu.org/api/tx/$txid
bh=$(myget $tx_url | jq -r .blockhash | grep .) || exit 1

tmp=$(mktemp)
myget $bh_url/$bh | safecat.sh $tmp
tx_ind=$(cat $tmp | jq -r .tx[] | nl -v 0 | grep $txid | cut -f1 | tr -d ' ' | grep .) || exit 1
height=$(cat $tmp | jq -r .height | grep .) || exit 1
rm $tmp
echo "${height}x${tx_ind}"
exit
}

bltx=$input
tx=$(myget $bh_url/${bltx%x*} \
      | jq -r .tx[] | nl -v 0 \
      | grep -E "^\s+${bltx##*x}\s+[0-9a-f]{64}" \
      | cut -f2)
echo $tx
