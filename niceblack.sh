#!/bin/sh

# backward compatible is when called with 2 arguments, <hash> <count>
#  and also without any argument
# new is <hash> only
# super new is <count> only (number of chars is <64)

VER=1.2.1
type md5 >/dev/null 2>&1 && md5=md5
VERSION=$VER-$(sed 1d $0 | ${md5:-"md5sum"} | cut -b-5)
tmp=$(mktemp)

usage() {
cat <<EOF
Usage: ${0##*/} <hash> <count>
    or ${0##*/} <hash>
    or ${0##*/} <count>
    or ${0##*/}
EOF
  exit 1
}

thousands() {
  sed -r -e ':L' -e 's=([0-9]+)([0-9]{3})=\1,\2=g' -e 't L'
}

gbhurl=http://ln.anyone.eu.org/getblockhash.txt
api=http://beh.bublina.eu.org/api/block/header

test "$1" = "-V" && { echo $VERSION; exit; }
test "$1" = "-h" && usage
test $# -le 2 || usage
test $# -ne 2 && {
  test $# -eq 0 && {
    hash=${1:-$(wget -qO - $gbhurl)}
    count=$(wget -qO - $api/$hash \
      | tr , '\n' | grep height | cut -d: -f2-)
  } || {
  if
    test $(echo $1 | wc -c) -lt 64
  then
    count=$(echo $1 | tr -cd '[0-9]')
    hash=$(wget -qO - $api/$count \
      | tr , '\n' | grep hash | cut -d: -f2- | tr -d '"')
  else
    hash=$1; shift
    count=$(wget -qO - $api/$hash \
      | tr , '\n' | grep height | cut -d: -f2-)
  fi
  }
} || {
  hash=$1; shift
  count=$1; shift
}

from=0
to=.
emptyplh="???? ???? ???? ????"

printblack.sh $count > $tmp || {
  cat <<EOF
  +------------------------------ -
  | block $(printf "$count" | thousands)
  +------------------------------ -
EOF
} > $tmp

{
echo $hash \
  | fold -s -w 16 \
  | sed -E 's/([0-9a-f]{4})(....)(....)(....)/\1 \2 \3 \4/g' \
  | {
  read line1
  read line2
  read line3
  read line4
cat << EOF
  ,---   .123 4567 89ab cdef   ---,
  | ..   ${line1:-$emptyplh}   .f |
  | 1.   ${line2:-$emptyplh}   1f |
  | 2.   ${line3:-$emptyplh}   2f |
  | 3.   ${line4:-$emptyplh}   3f |
  '===   ==== ==== ==== ====   ==='
   sf:   $(shortform.sh -o $count)
EOF
} | tr "$from" "$to"
} >> $tmp
cat $tmp && rm -f $tmp
