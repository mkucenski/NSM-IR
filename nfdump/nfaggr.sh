#!/usr/bin/env bash

NFCAPD_SRC_DIR="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
OUTPUT_DIR_BASE="$2"

for X in "$NFCAPD_SRC_DIR/"*; do
	AGGR=$(basename "$X")
	echo "$AGGR"
	nfdump -R "$X" -a -b -w "$OUTPUT_DIR_BASE/$AGGR.nfcapd"
done

