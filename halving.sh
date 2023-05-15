#!/bin/sh

cd ~/.bitcoin

mydo() {
  echo "~/.bitcoin $ $*"
  eval "$@"
}

bch.sh echo hello || exit 1
clear
mydo bitcoin-cli getblockcount
bc=$(bch.sh getblockcount)
echo bc=$bc
echo

mydo bitcoin-cli getblockhash $bc
bh=$(bch.sh getblockhash $bc)
echo "bh=\$(bch.sh getblockhash \$bc)"
#echo "~/.bitcoin $ bitcoin-cli getblockcount"
#echo $bc

echo
echo "This is the time of genesis block (gbt)"
echo "gb=\$(bitcoin-cli getblockhash 0)"
echo "gbt=\$(bitcoin-cli getblockheader \$gb | jq .time)"
gbt=1231006505
echo gbt=1231006505

echo
echo "This is the time of best block (bbt)"
bbt=$(bitcoin-cli getblockheader $bh | jq .time)
echo "bbt=\$(bitcoin-cli getblockheader \$bh | jq .time)"
echo bbt=$bbt
bts=$(echo "scale=8; ($bbt-$gbt)/$bc" | bc)
echo
echo This is average time to mine a block
echo "($bbt-$gbt)/$bc"
echo $bts
echo
echo "Now let's multiply that by 840000"
echo which is the block number of next
echo halving and get the date.
nh=$(echo "scale=8; $gbt+(840000*$bts)" | bc)
echo $nh
echo
mydo date -d "@$nh"
