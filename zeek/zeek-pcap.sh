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

PCAP="$(FULL_PATH "$PCAP")"
OUTPUTDIR="$(FULL_PATH "$OUTPUTDIR")"
_SCRIPTPATH="$(FULL_PATH "${BASH_SOURCE%/*}")"
_ZEEKSITE="local.zeek"

_LOGFILE="$OUTPUTDIR/zeek.log"
START "$0" "$_LOGFILE" "$*"
LOG "BASE64($_ZEEKSITE):" "$_LOGFILE"
LOG "$(BASE64_FILE "$_SCRIPTPATH/$_ZEEKSITE")" "$_LOGFILE"
LOG_VERSION "zeek" "$(zeek --version)" "$_LOGFILE"

_TMPDIR=$(MKTEMPDIR "$0" || exit 1)

# Zeek v4.0.4 doesn't support the `LogAscii::logdir` setting; only available on newer versions
# Instead, `pushd` into `_TMPDIR` so the initial Zeek logs get written there. Then, write the
# modified versions back to the provided `OUTPUTDIR`.
# zeek -C -r "$PCAP" LogAscii::json_timestamps=JSON::TS_ISO8601 LogAscii::use_json=T LogAscii::logdir="$_TMPDIR" local

pushd "$_TMPDIR" 2>&1 > /dev/null

CMD="zeek -C -r \"$PCAP\" LogAscii::json_timestamps=JSON::TS_ISO8601 LogAscii::use_json=T \"$_SCRIPTPATH/$_ZEEKSITE\""
EXEC_CMD "$CMD" "$_LOGFILE"

popd 2>&1 > /dev/null

for LOG in "$_TMPDIR"/*; do
	if [ -e "$LOG" ]; then
		LOG_TYPE="$(STRIP_EXTENSION "$(basename "$LOG")")"
		cat "$LOG" | jq -c ". + {event_type: \"$LOG_TYPE\", pcap_filename: \"$PCAP\"}" >> "$OUTPUTDIR/zeek-$LOG_TYPE.json"
	fi
done

rm -R "$_TMPDIR"

END "$0" "$_LOGFILE"

