#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAP="$1"
OUTPUTDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "PCAP" "OUTPUTDIR"
	USAGE_DESCRIPTION "This script executes Zeek in standalone/PCAP mode and slightly modified the logs for easier input into Graylog."
 	USAGE_EXAMPLE "$(basename "$0") /data/capture.pcap /data/zeek"
	exit 1
fi

_ZEEKSITE="${BASH_SOURCE%/*}/local.zeek"
_LOGFILE="$OUTPUTDIR/zeek.log"

START "$0" "$_LOGFILE" "$*"
LOG_VERSION "zeek" "$(zeek --version)" "$_LOGFILE"
LOG "" "$_LOGFILE"

${BASH_SOURCE%/*}/_zeek-pcap.sh "$PCAP" "$OUTPUTDIR" "$_ZEEKSITE" "$_LOGFILE"

LOG "" "$_LOGFILE"
LOG "BASE64_GZ($_ZEEKSITE):" "$_LOGFILE"
LOG "$(BASE64_GZ_FILE "$_ZEEKSITE")" "$_LOGFILE"
END "$0" "$_LOGFILE"

