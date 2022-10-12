# Classical Lightweight Scripts

## lch.sh

`lch.sh` was the first. It's name refers to `lightning-cli here`.
Example usage:

    cd .lightning/signet
    lch.sh getinfo

Another example:

    lch.sh .lightning/regtest stop


# ldh.sh

`ldh.sh` does something very similar, just runs the `lightningd`
instead of the client. There is no port-setting logic in the script
to keep it simple. Set `addr=address:port` in the `config` file.
Example:

    cd lightning-plebnet2/signet
    ldh.sh
    ... lightningd running ...

Another example:

    # bitcoind -signet is running
    mkdir -p /tmp/lightning/signet
    ldh.sh /tmp/lightning/signet


# bch.sh

`bch.sh` is `bitcoin-cli here` and again it just simplifies the command
line. Example:

    cd .bitcoin/signet
    bch.sh help

Another example:

    bch.sh .bitcoin/signet help


# bdh.sh

`bdh.sh` runs the `bitcoind`. Example:

    cd .bitcoin/regtest
    bdh.sh

Another example:

    bdh.sh .bitcoin/regtest


# gen.sh

Generate blocks (mainly for regtest).

Usage:

    # regtest bitcoind already running
    cd .bitcoin/regtest
    gen.sh 101


# payzero.sh

This is another C-Lightning script which executes a zero-fee payment
of a bolt11 (optionally with amount specified on the command line).
If the zero-fee payment can not be fulfilled, it will fail rather than
pay fees.

Usage:

     payzero.sh <bolt11> [amount] [description]

Or:

     payzero.sh <amount> <bolt11> [description]

Comes handy when paying [CoinOS](https://coinos.io/)-generated
invoices without an invoice-specified amount.

Another example:

    $ cd ~/.lightning
    $ payzero.sh $(lnaddr.sh anyone@coinos.io 1000)


# payabit.sh

Same as `payzero.sh`, but allows 1% fees.


# keysendzero.sh

Same as `payzero.sh`, but for `keysend` command.


# lnaddr.sh

Get an invoice for paying to Lightning Address.
Run a static test with:

    lnaddr.sh test@ln.anyone.eu.org


# invoice.sh

A simple `invoice` wrapper to use some extra options
like route hints.
