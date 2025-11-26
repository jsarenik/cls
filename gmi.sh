#!/bin/sh

bch.sh echo here 2>/dev/null | grep -q . || cd

bch.sh getmempoolinfo
