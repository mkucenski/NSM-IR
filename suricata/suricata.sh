#!/usr/bin/env bash

PCAP_DIR="$1"
OUTPUT_DIR="$2"

suricata -c /usr/local/etc/suricata/suricata.yaml -r "$PCAP_DIR" -l "$OUTPUT_DIR"

