#!/bin/busybox ash
#
# bitcoin-send.sh <address>

test "$1" = "" && { echo "Usage: ${0##*/} <address> [-f fee] [-c minconf] [-n numutxo] [text]"; exit 1; }
address=$1; shift
unset fee
test "$1" = "-f" && { fee=$2; shift 2; }
test "$1" = "-c" && { minconf=$2; shift 2; }
test "$1" = "-n" && { numutxo=$2; shift 2; }
data=$1
test "$data" = "" || data=$(echo $data | xxd -p -c320)

amount=0
first=0
{
echo '['
bcw.sh listunspent ${minconf:-0} \
  | jq -r \
   '.[] | .txid + " " + (.vout | tostring) + " " + (.amount * 1e8 | tostring)' \
  | shuf \
  | head -n ${numutxo:-15} \
  | tee /tmp/unspent \
  | while read txid vout amo
    do
      #echo $txid $vout >&2
      amo=${amo%%.*}
      test "$first" = "1" && printf ","
      first=1
      echo '''{"txid":"'"$txid"'","vout":'"$vout"'}'''
      amount="$amount + $amo"
      echo $amount > /tmp/amount
    done
echo ']'
} | tr -d '\n' > /tmp/rawtx
echo >> /tmp/rawtx
grep -qF '[]' /tmp/rawtx && exit 1
amount=$(printf "scale=8; (%s)/10^8\n" "$(cat /tmp/amount)" | bc)
amount=$(printf "%0.8f" "$amount")

dest() {
  {
  echo '['
  test "$1" = "all" && { echo '{"data":"7468697369737265616c6c7966756e6e796d6f72657468616e66756e6e797265616c6c797265616c6c790a"}]'; return 0; }
  echo '''{"'$address'":'$1'}'''
  test "$data" = "" || echo ''',{"data":"'$data'"}'''
  echo ']'
  } | tr -d '\n' > /tmp/dest
}

dest ${fee:-"$amount"}
TX=$(bch.sh createrawtransaction "$(cat /tmp/rawtx)" "$(cat /tmp/dest)" 0 false)
TXS=$(bcw.sh signrawtransactionwithwallet $TX | jq -r .hex)

VS=$(bch.sh decoderawtransaction $TXS | jq .vsize)
test "$fee" = "" -o "$fee" = "all" || {
  test "$fee" -gt $VS || { echo Fee too low.; exit 1; }
  VS=$fee
}
if
  test "$fee" = "all"
then
  amount=0
else
  amount=$(printf "%.8f" $(echo "scale=8; $amount - ($VS/100000000)" | bc))
fi

echo "$amount" | grep -q '^-' && exit 1
printf "dest: %s\n" ${address}
test "$fee" = "" || printf "fee: %s\n" ${fee}
printf "Would you like to send %s to dest? [y/N]: " ${amount}
read answer
test "$answer" = "y" || exit 1

dest ${fee:-"$amount"}
TX=$(bch.sh createrawtransaction "$(cat /tmp/rawtx)" "$(cat /tmp/dest)" 0 false)
TXS=$(bcw.sh signrawtransactionwithwallet $TX | jq -r .hex)
#VS=$(bch.sh decoderawtransaction $TXS | jq .vsize) ### redundant
bch.sh sendrawtransaction $TXS 1125
# rewrite to use jsonRPC
# --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "signrawtransactionwithwallet", "params": ["myhex"]}' -H 'content-type: text/plain;' http://127.0.0.1:8332/
