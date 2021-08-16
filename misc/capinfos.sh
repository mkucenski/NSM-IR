#!/usr/bin/env bash

IFS=$(echo -en "\n\b")

PCAP_SRC_DIR="$1"
OUTPUT_DIR_BASE="$2"

for X in $(find "$PCAP_SRC_DIR" -type f); do
	echo "$X"
	capinfos "$X" | tee "$OUTPUT_DIR_BASE/$(basename "$X").txt"
done

