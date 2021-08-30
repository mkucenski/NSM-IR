#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/common-include.sh" || exit 1

# Run dig/nslookup records consistently and store the results in a specific directory

# NOTE:	Querying the DNS system for "ANY" is not reliable; hence individual queries for
#			commonly interesting types. In some cases, "ANY" will not return certain records
#			while a specific query for "MX" will return an entry.

# dig +noall +comments +answer 199.72.247.162.dnsel.torproject.org

IP="$1"
if [ $# -eq 0 ]; then
	USAGE "IP" && exit 1
fi

ANSWER=$(dig +noall +comments +answer $IP.dnsel.torproject.org | grep '127.0.0.2')
if [ -n "$ANSWER" ]; then
	echo "$IP was identified as a Tor exit node ($ANSWER)."
else
	echo "$IP was **not** identified as a Tor exit node."
fi
echo
