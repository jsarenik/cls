#!/bin/sh

test "$1" = "-d" && { debug=1; shift; }
test "$1" = "" && exit
bc=${1:-$(bch.sh getblockcount)}

echo $1 | grep -q '^[0-9]\+$' && { bc=$1; shift; }
font=$(printf "banner\nbig\nblock\nscript\nsmall\nsmshadow\nslant\nsmslant\nstandard\n" | sed -n "$(($bc%9+1))p")

thousands() {
  sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1 \2=g;t L'
}
bcnew=$bc
test $(printf "$bc" | wc -c) -gt 6 \
  && bcnew=$(printf "$bc" | thousands)
test "$font" = "block" -o "$font" = "banner" \
  && bcnew=$(printf "$bc" | thousands) \
  || bcnew="block

{
figlet -w 48 -c -f $font \
  "$bcnew"
} | sed 's/\s\+$//' | uniq

test "$debug" = "1" -o "$1" = "-d" && echo $font