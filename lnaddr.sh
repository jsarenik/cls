#!/bin/sh

test $# -ge 1 || exit 1
PARAM=$1

USER=$(echo $PARAM | cut -d@ -f1)
HOST=$(echo $PARAM | cut -d@ -f2)
LNURL=https://$HOST/.well-known/lnurlp/$USER

wget -qO - "$LNURL" | jq . > /tmp/lnurl

getvalue() {
  grep "\"$1\":" /tmp/lnurl | cut -d: -f2- | tr -d ' ,"' | grep .
}

MAXLENGTH=$(getvalue "commentAllowed") && {
  printf "Enter comment (maxLength: %d): " $MAXLENGTH >&2
  read COMMENT
  COMMENT="&comment=$(echo $COMMENT | cut -b-$MAXLENGTH)"
}
MIN=$(getvalue "minSendable")
MAX=$(getvalue "maxSendable")
if test -n "$2"
then
  test $2 -le ${MAX:-0} -a $2 -ge ${MIN:-0} && AMOUNT=$2 \
    || { echo "Amount not in range $MIN - $MAX. Exiting." >&2;
         exit 1; }
else
  AMOUNT=$MIN
fi
CB=$(getvalue "callback")
URL="$CB?amount=$AMOUNT$COMMENT"
test -n "$URL" && echo $URL >&2 || echo $LNURL >&2

wget -qO - "$URL" || echo >&2
EXIT=$?
exit $EXIT
