#!/bin/sh

lock=/tmp/mmh
test "$1" = "-f" && {
  rmdir $lock
  shift
}

{
  for i in 1 2 3; do bitcoin-cli echo hello | grep -q . || { LC_ALL=C date -u; sleep 5; }; done
} || exit 1
mkdir $lock || exit 1

BN=89999115000
hp=192.168.3.118:12321
ping -qc 1 -W5 -w5 ${hp%:*} >/dev/null || { hp=anyone.eu.org; scheme=https; }
url=${scheme:-"http"}://$hp
out=/dev/shm/mempool.copyhere
touch $out 2>/dev/null || out=$HOME/mempool.copyhere
rm -f $out

uptime=$(bitcoin-cli uptime) || exit 1
test $uptime -gt 113 || bitcoin-cli setnetworkactive false

# 1st pass
rm -f $out
bitcoin-cli getrawmempool | sed '1d;$d' | tr -d ' ",' | sort > $out-txt
wget -qO - $url/mymempool.txt | sort > $out-mymtxt
wget -O $out $url/mempool.copy.dat
bitcoin-cli -rpcclienttimeout=0 importmempool $out

# 2nd pass - with prioritized transactions
secondp() {
sort < $out-mymtxt \
  | comm -2 -3 - $out-txt \
  | xargs -I TXID -n 1 -P 4 bitcoin-cli prioritisetransaction TXID "0.0" $BN \
    >/dev/null 2>&1
bitcoin-cli -rpcclienttimeout=0 importmempool $out '{
"apply_fee_delta_priority":true,
"apply_unbroadcast_set":true}'
}

#for i in $(seq 2)
#do
#  tail -1 /dev/shm/bitcoind.log | grep -q " 0 failed," && break
#  secondp
#done

rm -f $out $out-txt $out-mymtxt
bitcoin-cli setnetworkactive true
date -u

# optiontal clean-up would mess up logs so maybe exit before here
bitcoin-cli getprioritisedtransactions \
  | grep -e '^  "' -e '"fee_delta":' \
  | tr -d '  {,' | paste -d" " - - \
  | sed 's/"fee_delta":/"0.0" +/' \
  | sed 's/+-//' | tr '+' '-' | tr -d : \
  | xargs -n 3 -P 4 bitcoin-cli prioritisetransaction \
    >/dev/null 2>&1

date -u
rmdir $lock
