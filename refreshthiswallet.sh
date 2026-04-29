#!/bin/sh

net=$(hnet.sh)
test -r wallet.dat || { echo Enter wallet directory first; exit 1; }
#test -r "$1" || { echo Enter listdescriptors true text file as first arg; exit 1; }

w=${PWD##*/}
touch $w.json

pke=$(bch.sh getwalletinfo | jq -r .private_keys_enabled)
pkei=$(eval $pke && echo false || echo true)
echo $pke $pkei

test -w $w.json \
&& json=$PWD/$w.json || {
  json=$(mktemp /tmp/json-XXXXXX)
}

test -r $json.fbackup || {
bch.sh listdescriptors $pke \
  | safecat.sh $json.fbackup
}

test -r $json || {
bch.sh listdescriptors $pke | sed 's/"timestamp".*$/"timestamp":"now",/' | jq -rc .descriptors \
  | safecat.sh $json
}

ulw.sh

old=wallet.dat-old
test -r $old && rm wallet.dat || {
  mv wallet.dat $old
}

cd ..

bch.sh createwallet $w $pkei true
cd $w

bch.sh -stdin importdescriptors < $json

ph=$(ph.sh) && bch.sh rescanblockchain $ph

echo $json | grep '^/tmp/' && rm $json
