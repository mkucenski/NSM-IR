#!/usr/bin/env bash

IFS=$(echo -en "\n\b")

PCAP_SRC_DIR="$1"
OUTPUT_DIR_BASE="$2"

for X in $(find "$PCAP_SRC_DIR" -type f); do
	PCAP_NAME="$(basename "$X")"
	echo "$PCAP_NAME"

	ndpiReader -i "$X" -C "$OUTPUT_DIR_BASE/$PCAP_NAME.csv" | tee -a "$OUTPUT_DIR_BASE/$PCAP_NAME.txt"

	# Remove the headers so they don't get imported by filebeat
	sed -i "" '1d' "$OUTPUT_DIR_BASE/$PCAP_NAME.csv"
done

