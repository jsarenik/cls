#!/bin/sh
#
# https://coderwall.com/p/lyrjsq/extract-your-external-ip-using-command-line-tools
# https://dev.to/adityathebe/a-handy-way-to-know-your-public-ip-address-with-dns-servers-4nmn

mydig() {
  timeout 1 dig $* | tr -d '"' | grep . && exit
}

mycurl() {
  timeout 1 curl -4 $* && echo && exit
}

mydig -4 +short myip.opendns.com a @resolver1.opendns.com
mydig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com
mydig -4 @ns1-1.akamaitech.net ANY whoami.akamai.net +short
timeout 1 curl -s eth0.me && exit
mycurl -s ifconfig.me/ip
mycurl -s ipecho.net/plain
mycurl -s icanhazip.com
mycurl -s http://whatismyip.akamai.com/
#curl curlmyip.com
#curl l2.io/ip
#curl ip.appspot.com
curl -4 ifconfig.io
curl ipaddress.sh

# Following is for IPv6
ping -6 -c1 resolver1.opendns.com >/dev/null 2>&1 && {
  dig -6 +short myip.opendns.com aaaa @resolver1.opendns.com
  dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '"'
}
