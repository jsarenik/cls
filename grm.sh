#!/bin/sh

bch.sh getrawmempool $1 | tr -d ' ",[]' | sed '1d;$d'
