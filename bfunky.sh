#!/bin/sh -c "echo source me"
# source this file or embed it in your script

# Bitcoin Daemon Here - starts a bitcoind in current directory
bdh() {
  test -d "$1" && { cd "$1"; shift; }
  OPTS="$@"
  sh -se <<-EOF
	test "\${PWD##*/}" = "signet" && chain=signet
	test "\${PWD##*/}" = "testnet3" && chain=test
	test "\${PWD##*/}" = "regtest" && chain=regtest
	test "\$chain" = "" || bd=\${PWD%/*}

	exec bitcoind "-datadir=\${bd:-\$PWD}" -chain=\${chain:-main} $OPTS
	EOF
}

# Bitcoin Client Here - starts a bitcoin-cli in current directory
bch() {
  test -d "$1" && { cd "$1"; shift; }
  OPTS="$@"
  sh -se <<-EOF
	test "\${PWD##*/}" = "signet" && chain=signet
	test "\${PWD##*/}" = "testnet3" && chain=test
	test "\${PWD##*/}" = "regtest" && chain=regtest
	test "\$chain" = "" || bd=\${PWD%/*}

	exec bitcoin-cli "-datadir=\${bd:-\$PWD}" -chain=\${chain:-main} $OPTS
	EOF
}

# Lightning Daemon Here - starts a lightningd in current directory
ldh() {
  test -d "$1" && { cd "$1"; shift; }
  OPTS="$@"
  sh -se <<-EOF
	test "\${PWD##*/}" = "bitcoin" && net=bitcoin
	test "\${PWD##*/}" = "testnet" && net=testnet
	test "\${PWD##*/}" = "signet" && net=signet
	test "\${PWD##*/}" = "regtest" && net=regtest

	exec lightningd "--lightning-dir=\${PWD%/*}" "--network=\$net" $OPTS
	EOF
}

# Lightning Client Here - starts a lightning-cli in current directory
lch() {
  test -d "$1" && { cd "$1"; shift; }
  test -d bitcoin && cd bitcoin
  OPTS="$@"
  sh -se <<-EOF
	test "\${PWD##*/}" = "bitcoin" && net=bitcoin
	test "\${PWD##*/}" = "testnet" && net=testnet
	test "\${PWD##*/}" = "signet" && net=signet
	test "\${PWD##*/}" = "regtest" && net=regtest

	exec timeout 600 \
	  lightning-cli "--lightning-dir=\${PWD%/*}" "--network=\$net" $OPTS
	EOF
}