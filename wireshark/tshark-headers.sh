#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAP="$1"

if [ $# -eq 0 ]; then
	USAGE "PCAP"
	USAGE_DESCRIPTION "This script extract FRAME and ETHERNET header records from a PCAP file into a JSON file suitable for import into Graylog. It does not attempt to parse IP records, but rather relies on the CommunityID value for cross-referencing those lower-level details via other tools (e.g. Suricata, Zeek, NetFlow, etc.)."
	exit 1
fi

tshark -r "$PCAP" -T ek -PV -J "frame eth communityid" | jq -c  '{timestamp: .timestamp} * {communityid: .layers.communityid} * {src_ip: .source} * {src_port: .srcport} * {dst_ip: .destination} * {dst_port: .dstport} * {protocol: .protocol} * {message: .info} * .layers.frame * .layers.eth' 2>/dev/null

