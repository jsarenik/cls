fr=$(bch.sh estimatesmartfee 1 | grep feerate | cut -d: -f2- | tr -d '" .,') 
#fr=00049000
#fr=$(echo $fr | tr -d '" .,') 
echo $fr | grep '^[0-9]\+$'
if
  test $fr -le 50500
then
  echo tx1
#return
cat tx1.sr | bch.sh -stdin sendrawtransaction \
  | tee -a tx1.id
else
  echo tx2
#return
cat tx2.sr | bch.sh -stdin sendrawtransaction \
  | tee -a tx2.id
fi

echo Transaction sent
