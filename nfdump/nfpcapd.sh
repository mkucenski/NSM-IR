#!/usr/bin/env bash

PCAP_SRC_DIR="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
OUTPUT_DIR_BASE="$2"

for X in "$PCAP_SRC_DIR/"*; do
	echo "$X"
	PCAP=$(basename "$X")
	mkdir -p "$OUTPUT_DIR_BASE/$PCAP" 2>&1 > /dev/null
	if [ -z "$(ls -A "$OUTPUT_DIR_BASE/$PCAP")" ]; then
		nfpcapd -r "$X" -t 3000 -l "$OUTPUT_DIR_BASE/$PCAP"
	fi
done

