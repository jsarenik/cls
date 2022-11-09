#!/bin/sh

W=$(bch.sh listwallets | tr -d '\[\],\" ' | sed '/^$/d' | tail -1)
bch.sh -rpcwallet=$W "$@"
