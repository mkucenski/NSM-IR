#!/usr/bin/env bash

PCAP_SRC_DIR="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
OUTPUT_DIR_BASE="$2"

for X in "$PCAP_SRC_DIR/"*; do
	echo "$X"
	PCAP=$(basename "$X")
	mkdir -p "$OUTPUT_DIR_BASE/$PCAP" 2>&1 > /dev/null
	if [ -z "$(ls -A "$OUTPUT_DIR_BASE/$PCAP")" ]; then
		pushd "$OUTPUT_DIR_BASE/$PCAP" 2>&1 > /dev/null

		zeek -C -r "$X" LogAscii::gzip_level=6 LogAscii::use_json=T;

		popd 2>&1 > /dev/null
	fi
done
