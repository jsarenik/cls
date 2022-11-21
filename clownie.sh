#!/bin/sh

PATH=/busybox:$PATH
D=$(date -u)
BCO=-rpcwallet=default

test "$1" = "-o" && { ONCE=1; shift; }
exec 2>/dev/null

capital() {
  R=${1#?}
  printf '%s' "${1%%$R}" | tr '[:lower:]' '[:upper:]'
  echo $R
}

NET=$(bch.sh getblockchaininfo | jq -r .chain)
NET=$(capital $NET)
NET=${NET%net}net
test "$NET" = "Signet" && NET=" Signet"
test "$NET" = "Regtestnet" && NET=Regtest
test "$NET" = "Mainnet" && NET=Bitcoin
C='{ printf "scale=8; "; bch.sh $BCO getbalances | grep "^    " | cut -d: -f2 | tr -d " \n" | tr "," "+"; echo; } | bc'
WHERE=$PWD
rm -rf /tmp/genaddrs*
mkdir -p $WHERE/addrd
genaddr() {
  type=${1:-"bech32"}
  echo "Generating new $type address"
  bch.sh $BCO getnewaddress "" ${type} > $WHERE/addrd/${type}
}
chaddr() {
  type=${1:-"bech32"}
  F=$WHERE/addrd/${type}
  test -s "$F" && { bch.sh $BCO listreceivedbyaddress 0 \
                      | grep addr | grep -qf $F \
                    || return 0; }
  genaddr ${type}
}
genaddrs() {
#printf '[H[2J' # clear
# ESC [nG - move to indicated column n on current line
# console_codes(4) man page
test "$ONCE" = "1" || {
  printf "[?25l" # invisible cursor (tput ivis)
  trap 'tput cnorm; exit' QUIT INT
  printf '[1F' # erase whole line (last line)
  printf '[2K' # erase whole line (last line)
  printf '[H' # reset cursor (overwrite by next cat, no clear)
}
cat <<EOF
 bech32m: [58G######### [11G${A1}    [74G.====.
 bech32:  ${A2}         [57G(  0 o 0  )      |drop|
 p2sh-segwit: ${A3}       [59G\ \_/ /        |some|
 legacy:      ${A4} [53G${NET}\`---'clowniE  |fine|
$ bitcoin-cli -datadir=\$PWD getbalances | magic           _/   \_        |gold|
EOF
printf "%s" \
"             [13D$B [1D  [14G # ssh -o \"HostKeyAlgorithms ssh-rsa\" -c aes256-cbc ln.uk.ms ####"
# bolt12(CLN): lno1pqpq86q29pqjqun9vdjkuapqdanxvetjypmrqt33xqhrytfnxgujcgrdw4k8g6tsd3jjqatnv50zqt09cregl8tazrqvpd0vjt5rlxl5phhjhaqps8q0gvcv2ljc4ps9
}

OLD=/tmp/genaddrs$$-old
NEW=/tmp/genaddrs$$-new
echo init | tee $NEW > $OLD

B=0.00000000
BAL=$(eval $C)
B=$(printf "%.8f" $BAL)

test "$ONCE" = "1" || printf '[H[2J' # clear
while true
do

# Check if the addresses have been used
for t in bech32m bech32 p2sh-segwit legacy
do
  { chaddr ${t}; } >/dev/null 2>&1
done

BAL=$(eval $C)
B=$(printf "%.8f" $BAL)
A1=$(cat $WHERE/addrd/bech32m | grep . || echo no bech32m address)
A2=$(cat $WHERE/addrd/bech32)
A3=$(cat $WHERE/addrd/p2sh-segwit)
A4=$(cat $WHERE/addrd/legacy)

genaddrs > $NEW
if
  cmp $OLD $NEW >/dev/null 2>&1
then
  :
else
  cat $NEW | tee $OLD
fi

test "$ONCE" = "1" && { echo; exit 0; }
sleep 2
done
