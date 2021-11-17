#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAP_DIR="$1"
OUTPUT_DIR="$2"

if [ $# -eq 0 ]; then
	USAGE "PCAP_DIR" "OUTPUT_DIR"
	USAGE_DESCRIPTION "This script executes Suricata against the specified PCAP_DIR and places all log files in OUTPUT_DIR."
 	USAGE_EXAMPLE "$(basename "$0") /data/pcap/ /data/suricata/"
	exit 1
fi

suricata -c "${BASH_SOURCE%/*}/suricata-6x.yaml" -r "$PCAP_DIR" -l "$OUTPUT_DIR"

