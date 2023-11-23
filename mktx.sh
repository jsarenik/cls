#!/bin/sh
#
# Usage: mktx.sh < tx.in
# the input contains both types of lines:
#  txid:vout
#  addr,amount
# 
# Legacy usage: mktx.sh <dir>
# the dir contains two text files:
# in
#  txid:vout
# out
#  addr,amount

tmp=$(mktemp)
if
  test -n "$1" && test -d $1
then
  cat $1/in $1/out > $tmp
else
  cat > $tmp
fi
oldifs=$IFS

{
echo '['
IFS=:
first=1
grep -v "^#" $tmp | grep ":" | shuf | while read txid vout
do
test "$first" = 1 || echo ,
first=0
cat <<EOF
{"txid":"$txid","vout":$vout}
EOF
done
echo ']'
} | tr -d '\n '; echo

{
echo '['
IFS=,
first=1
grep -v "^#" $tmp | grep "," | shuf | while read addr amount
do
test "$first" = 1 || echo ,
first=0
cat <<EOF
{"$addr":$amount}
EOF
done
echo ']'
} | tr -d '\n '; echo

cat <<EOF
0
true
EOF
rm $tmp
