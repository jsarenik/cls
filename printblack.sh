#!/bin/sh

VER=1.2.2
type md5 >/dev/null 2>&1 && md5=md5
VERSION=$VER-$(sed 1d $0 | ${md5:-"md5sum"} | cut -b-5)

test "$1" = "-V" && { echo $VERSION; exit; }

type figlet >/dev/null 2>&1 || exit 1
test "$1" = "-d" && { debug=1; shift; }
test "$1" = "" && exit
bc=${1:-$(bch.sh getblockcount)}

echo $1 | grep -q '^[0-9]\+$' && { bc=$1; shift; }
font=$(printf "banner\nbig\nblock\nscript\nsmall\nsmshadow\nslant\nsmslant\nstandard\n" | sed -n "$(($bc%9+1))p")

test "$debug" = "1" -o "$1" = "-d" && echo $font

thousands() {
  sed -r -e ':L' -e 's=([0-9]+)([0-9]{3})=\1 \2=g' -e 't L'
}
bcnew=$bc
test $(printf "$bc" | wc -c) -gt 6 \
  && bcnew=$(printf "$bc" | thousands)
test "$font" = "block" -o "$font" = "banner" \
  && bcnew=$(printf "$bc" | thousands) \
  || bcnew="block $bcnew"

{
figlet -w 41 -c -f $font \
  "$bcnew"
} | sed 's/^[[:space:]]*$//g' | uniq

true
