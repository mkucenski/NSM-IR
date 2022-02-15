#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAP="$1"

if [ $# -eq 0 ]; then
	USAGE "PCAP"
	USAGE_DESCRIPTION "This script extract FRAME, ETHERNET, and IP header records from a PCAP file into JSON suitable for import into Graylog."
 	USAGE_EXAMPLE "$(basename "$0") capture.pcap > capture.json"
 	USAGE_EXAMPLE "$(basename "$0") capture.pcap | gzip -c > capture.json.gz"
 	USAGE_EXAMPLE "$(basename "$0") capture.pcap | jq | less -i"
	exit 1
fi

tshark -C "tshark" -r "$PCAP" -T ek -PV -J "frame eth ip communityid" | jq -c -f "${BASH_SOURCE%/*}/tshark-headers.jq"

