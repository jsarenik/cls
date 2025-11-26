#!/bin/sh
curl -sSL https://mempool.space/api/mempool | jq . | head -4
