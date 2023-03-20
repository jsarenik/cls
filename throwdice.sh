#!/bin/sh

ls /sys >/dev/null 2>&1 || exit

test "$1" = "-n" && exit
grep -qE '(powersave|userspace)' \
    /sys/devices/system/cpu/cpufreq/policy0/scaling_governor \
    2>/dev/null \
  || exit

chain=$(bch.sh getblockchaininfo | tr -d ' ",' \
  | grep ^chain: | cut -d: -f2 | grep .) \
  || exit
test "$chain" = "main" || exit

echo Throwing dice...
nohup bcw.sh -generate 1 1234567 </dev/null >&0 2>&1 &
