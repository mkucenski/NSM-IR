#!/usr/bin/env bash

IFS=$(echo -en "\n\b")

PCAP_SRC_DIR="$1"
OUTPUT_DIR_BASE="$2"

for X in $(find "$PCAP_SRC_DIR" -type f); do
	echo "$X"
	ndpiReader -r | tee "$OUTPUT_DIR_BASE/$(basename "$X").txt"
	ndpiReader -i "$X" -C "$OUTPUT_DIR_BASE/$(basename "$X").csv" | tee -a "$OUTPUT_DIR_BASE/$(basename "$X").txt"
done

