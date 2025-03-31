#!/bin/sh

BN=89999115000
hp=anyone.eu.org
bitcoin-cli echo hello | grep -q . || exit 1
ping -qc 1 -W5 -w5 $hp >/dev/null || { hp=192.168.3.118:12321; scheme=http; }
url=${scheme:-"https"}://$hp
out=/dev/shm/mempool.copy 
touch $out 2>/dev/null || out=$HOME/mempool.copy
rm -f $out
uptime=$(bitcoin-cli uptime) || exit 1
test $uptime -gt 613 || bitcoin-cli setnetworkactive false

# 2nd pass - with prioritized transactions
wget -O $out $url/mempool.copy.dat
bitcoin-cli importmempool $out '{
"apply_fee_delta_priority":true,
"apply_unbroadcast_set":true}'
wget -O $out $url/mempool.copy.dat
bitcoin-cli getrawmempool | sed '1d;$d' | tr -d ' ",' | sort > $out-txt
wget -qO - $url/mymempool.txt \
  | sort \
  | comm -2 -3 - $out-txt \
  | xargs -I TXID -n 1 -P 200 bitcoin-cli prioritisetransaction TXID "0.0" $BN \
    >/dev/null 2>&1
bitcoin-cli importmempool $out '{
"apply_fee_delta_priority":true,
"apply_unbroadcast_set":true}'
rm -f $out $out-txt
bitcoin-cli setnetworkactive true
date -u

# optiontal clean-up would mess up logs so maybe exit before here
bitcoin-cli getprioritisedtransactions \
  | grep -e '^  "' -e '"fee_delta":' \
  | tr -d '  {,' | paste -d" " - - \
  | sed 's/"fee_delta":/"0.0" +/' \
  | sed 's/+-//' | tr '+' '-' | tr -d : \
  | xargs -n 3 -P 20 bitcoin-cli prioritisetransaction \
    >/dev/null 2>&1

date -u
