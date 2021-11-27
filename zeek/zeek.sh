#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAPDIR="$1"
OUTPUTDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "PCAPDIR" "OUTPUTDIR"
	USAGE_DESCRIPTION "This script executes Zeek in standalone/PCAP mode and slightly modified the logs for easier input into Graylog."
 	USAGE_EXAMPLE "$(basename "$0") /data/pcaps /data/zeek"
	exit 1
fi

for PCAP in $(find "$PCAPDIR" -type f); do
	echo "$PCAP"
	"${BASH_SOURCE%/*}/zeek-pcap.sh" "$PCAP" "$OUTPUTDIR"
done

