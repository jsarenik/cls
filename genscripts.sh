#!/bin/sh

#for b in bitcoin-cli bitcoin-tx bitcoin-util bitcoin-wallet bitcoind
for b in "$@"
do
  mkdir lib real 2>/dev/null
  file -b $b | grep -qw "ELF" || continue
  mv $b real
  { ldd real/$b | grep 'ld-linux' | awk '{print $1}';
    ldd real/$b | grep '=>' | awk '{print $3}'; } \
    | while read l; do cp $l lib; done

  {
  cat <<-EOF
	#!/bin/sh
	a="/\$0"; a=\${a%/*}; a=\${a:-.}; a=\${a#/}/; B=\$(cd "\$a" || true; pwd)
	export LD_LIBRARY_PATH=\$B/lib
	exec \$B/real/$b "\$@"
	EOF
  } > $b
  chmod a+x $b
done
