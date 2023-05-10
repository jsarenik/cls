#!/bin/sh

# backward compatible is when called with 2 arguments, <hash> <count>
#  and also without any argument
# new is <hash> only
# super new is <count> only (number of chars is <64)

VER=1.3.1
type md5 >/dev/null 2>&1 && md5=md5
VERSION=$VER-$(sed 1d $0 | ${md5:-"md5sum"} | cut -b-5)
test "$1" = "-o" && { only=1; shift; }

usage() {
cat <<EOF
Usage: ${0##*/} <hash> <count>
    or ${0##*/} <hash>
    or ${0##*/} <count>
    or ${0##*/}
    or ${0##*/} -o [...]
EOF
  exit 1
}

thousands() {
  sed -r -e ':L' -e 's=([0-9]+)([0-9]{3})=\1,\2=g' -e 't L'
}

test "$1" = "-V" && { echo $VERSION; exit; }
test "$1" = "-h" && usage
test $# -le 2 || usage
test $# -lt 2 && {
  test $# -eq 0 && {
    hash=${1:-$(bch.sh getbestblockhash)}
    count=$(bch.sh getblockheader $hash \
      | tr , '\n' | grep -w height | cut -d: -f2-)
  } || {
  if
    count=$(echo $1 | tr -cd '[0-9]')
    test "$count" = "$1"
  then
    hash=$(bch.sh getblockheader $(bch.sh getblockhash $count) \
      | tr , '\n' | grep -w hash | cut -d: -f2- | tr -d '"')
  else
    hash=$1
    count=$(bch.sh getblockheader $hash \
      | tr , '\n' | grep -w height | cut -d: -f2-)
  fi
  }
} || {
  hash=$1
  count=$2
}

from=0
to=.

test "$only" = "1" || printf "$count: "
echo $hash \
  | fold -s -w 4 \
  | sed -n -e '/^0000$/d;/0/p;$p' \
  | uniq \
  | tr '\n' ' ' | cut -b-19 \
  | tr "$from" "$to"
