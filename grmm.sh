#!/bin/sh

{
curl -sSL "https://mempool.space/api/mempool/txids" | tr , '\n' | tr -d ' "]['
echo
}
