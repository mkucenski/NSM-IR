#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAPDIR="$1"
OUTPUTDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "PCAPDIR" "OUTPUTDIR"
	USAGE_DESCRIPTION "This script executes against the specified PCAPDIR and places all log files in OUTPUTDIR."
 	USAGE_EXAMPLE "$(basename "$0") /data/pcap/ /data/output/"
	exit 1
fi

PCAPDIR="$(FULL_PATH "$PCAPDIR")"
_LOGFILE="$OUTPUTDIR/ndpi.log"

START "$0" "$_LOGFILE" "$*"
LOG_VERSION "nDPI" "$(ndpiReader --help | head -n 1 | $SEDCMD -r 's/Welcome to //')" "$_LOGFILE"
LOG "" "$_LOGFILE"

for _PCAP in "$PCAPDIR"/*; do
	echo "$_PCAP"
	_PCAPNAME="$(STRIP_EXTENSION "$(basename "$_PCAP")")"

	CMD="ndpiReader -v 3 -V 1 -z -i \"$_PCAP\" -C \"$OUTPUTDIR/$_PCAPNAME.csv\" > \"$OUTPUTDIR/$_PCAPNAME.txt\""
	EXEC_CMD "$CMD" "$_LOGFILE"

	# Remove the headers so they don't get imported by filebeat
	CMD="sed -i \"\" '1d' \"$OUTPUTDIR/$_PCAPNAME.csv\""
	EXEC_CMD "$CMD" "$_LOGFILE"
done

LOG "" "$_LOGFILE"
END "$0" "$_LOGFILE"

