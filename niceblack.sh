#!/bin/sh

# backward compatible is when called with 2 arguments, <hash> <count>
#  and also without any argument
# new is <hash> only
# super new is <count> only (number of chars is <64)

VER=1.3.2
type md5 >/dev/null 2>&1 && md5=md5
VERSION=$VER-$(sed 1d $0 | ${md5:-"md5sum"} | cut -b-5)
tmp=$(mktemp)
exec 2>/dev/null

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

. /dev/shm/UpdateTip-bitcoin
test "$1" = "-V" && { echo $VERSION; exit; }
test "$1" = "-h" && usage
test $# -le 2 || usage
test $# -ne 2 && {
  test $# -eq 0 && {
    hash=${best:-$(bch.sh getbestblockhash)}
    count=${height:-$(bch.sh getblockheader $hash \
      | tr , '\n' | grep -w height | cut -d: -f2-)}
  } || {
  if
    test $(echo $1 | wc -c) -lt 64
  then
    count=$(echo $1 | tr -cd '[0-9]')
    hash=$(bch.sh getblockheader $(bch.sh getblockhash $count) \
      | tr , '\n' | grep -w hash | cut -d: -f2- | tr -d '"')
  else
    hash=$1; shift
    count=$(bch.sh getblockheader $hash \
      | tr , '\n' | grep -w height | cut -d: -f2-)
  fi
  }
} || {
  hash=$1; shift
  count=$1; shift
}

from=0
to=.
emptyplh="0000 0000 0000 0000"
emptypll="0000 0000 0000 1f1f"

BH=${hash:-0000000000000000000000000000000000000000000000000000000000001f1f}

: Following is the shortform
last=$(echo $BH | cut -b61-64)
a=$(echo $BH | cut -b-60 \
  | fold -w 4 \
  | grep -Ev '^(0000|[^0]{4})$')
R=$(echo $a $last | cut -b-20)
sf=$({ echo $R | grep "$last$" \
  || echo $R M; } | tr "0\n" ". ")

: Following is the shortkode
nz=$(echo $BH | fold -w 4 \
  | grep -E '^[^0]{4}$' | wc -l)
z=$(echo $BH | fold -w 4 \
  | grep '^0000$' | wc -l)
sk=$(printf "%s %x%x" $last ${nz} ${z} \
  | tr "0\n" ". ")

hashtobinary() {
  tobin=$(printf "%s" $(echo "ibase=16;obase=2;$(echo $hash | tr '[a-z]' '[A-Z]')" \
    | busybox bc | tr -d '\\\n'))
  len=$(printf "%s" "$tobin" | wc -c)
  missing=$((256-$len))
  {
  for i in $(seq $missing); do printf "0"; done;
  echo $tobin
  } | fold -w 32 | grep -m1 1 | fold -w 16 | tr '01\n' '.| ' | cut -b-33; echo
}

printblack.sh $count > $tmp || {
  cat <<EOF
  +------------------------------ -
  | block $(printf "$count" | thousands)
  +------------------------------ -
EOF
} > $tmp

{
echo $hash \
  | fold -w 4 \
  | paste -d " " - - - - \
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
  | 3.   ${line4:-$emptypll}   3f |
  '===   ==== ==== ==== ====   ==='
   sk:   $sk
EOF
#   sf:   $sf
#  $(hashtobinary)
} | tr "$from" "$to"
} >> $tmp
cat $tmp | cut -c-37 && rm -f $tmp
