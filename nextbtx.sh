#!/bin/sh

tmp=$(mktemp /dev/shm/nextbtx-XXXXXX)
#bitcoin-cli getblocktemplate '{"rules": ["segwit"]}' | jq -r '.transactions[] | select ( .depends == [] ) | .txid, (((400 * .fee / .weight) | trunc)/100)' | paste -d" " - - | sort -k 2 -n > $tmp
bch.sh getblocktemplate '{"rules": ["segwit"]}' | jq -r '.transactions[] | select ( .depends == [] ) | .txid, (((400 * .fee / .weight) | trunc)/100)' | paste -d" " - - | sort -k 2 -n > $tmp

#head -1 $tmp
#tail -n +$(((`wc -l <$tmp` / 2) + 1)) $tmp | head -n 1
bch.sh getblockchaininfo | grep -w chain | tr -d '" ,'
shortkode.sh -b
tail -1 $tmp | cut -d " " -f1 | fold -w4 | tr '\n0' ' .'
echo
tail -1 $tmp | cut -d " " -f1
shortkode.sh $(tail -1 $tmp | cut -d" " -f1)
#niceblack.sh $(tail -1 $tmp | cut -d" " -f1)
rm -f $tmp
#bitcoin-cli getblocktemplate '{"rules": ["segwit"]}' | jq -r 'def ceil: if . | floor == . then . else . + 1.0 | floor end; .transactions[] | .txid, (4 * .fee / .weight) | ceil' | paste -d" " - - | sort -k 2 -n | tail -1
