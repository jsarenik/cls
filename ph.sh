#!/bin/sh
bch.sh ${1} getblockchaininfo | jq -r .pruneheight
