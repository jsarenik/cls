#!/bin/sh -c "echo source me"
# source this file or embed it in your script

# Bitcoin Daemon Here - starts a bitcoind in current directory
bdh() {
  test -d "$1" && { MYDIR="$1"; shift; }
  OPTS="$@"
  sh -se <<-EOF
	test "$MYDIR" = "" || cd "$MYDIR"

	test "\${PWD##*/}" = "signet" && chain=signet
	test "\${PWD##*/}" = "testnet3" && chain=test
	test "\${PWD##*/}" = "regtest" && chain=regtest
	test "\$chain" = "" || bd=\${PWD%/*}

	exec bitcoind "-datadir=\${bd:-\$PWD}" -chain=\${chain:-main} $OPTS
	EOF
}

# Bitcoin Client Here - starts a bitcoin-cli in current directory
bch() {
  test -d "$1" && { MYDIR="$1"; shift; }
  OPTS="$@"
  sh -se <<-EOF
	test "$MYDIR" = "" || cd "$MYDIR"

	test "\${PWD##*/}" = "signet" && chain=signet
	test "\${PWD##*/}" = "testnet3" && chain=test
	test "\${PWD##*/}" = "regtest" && chain=regtest
	test "\$chain" = "" || bd=\${PWD%/*}

	exec bitcoin-cli "-datadir=\${bd:-\$PWD}" -chain=\${chain:-main} $OPTS
	EOF
}
