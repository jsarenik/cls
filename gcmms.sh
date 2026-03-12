#!/bin/sh

lock=/tmp/lock-gcmms
mkdir $lock || exit 1

local=$(gmi.sh | grep -w size | tr -cd '[0-9]' | grep .)
memps=$(gmi-m.sh | grep -w count | tr -cd '[0-9]' | grep .)

echo local $local m.s $memps
test "$local" -lt "$(($memps-1000))" && {
  ping -c1 192.168.3.118 && mymempoolhere.sh || {
    pgrep -f mmsnew.sh || ash ~/mmsnew.sh
  }
}

rmdir $lock
