#!/bin/sh

hash=${1:-$(wget -qO - http://ln.anyone.eu.org/getblockhash.txt)}
count=${2:-$(wget -qO - http://ln.anyone.eu.org/getblockcount.txt)}
tmp=$PREFIX/tmp/middle

cat > $tmp-left <<EOF
       | ..  
       | 1.  
       | 2.  
       | 3.  
EOF
cat > $tmp-right <<EOF
  .f |
  1f |
  2f |
  3f |
EOF

printblock.sh $count
echo "       ,---   .123 4567 89ab cdef   ---,"
#echo '       |###   #### #### #### ####   ###|'
echo $hash \
  | sed -E 's/.{16}/&\n/g' \
  | sed '$d; s/..../& /g; s/ $//' \
  | sed 's/0/./g' \
  | paste -d " " $tmp-left - $tmp-right
echo "       '===   ==== ==== ==== ====   ==='"
