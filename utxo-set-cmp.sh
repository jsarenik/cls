#!/bin/sh -x

P=api/blockchain/utxo-set

curl -s https://be.anyone.eu.org/$P | jq .muhash
curl -s https://bitcoinexplorer.org/$P | jq .muhash
