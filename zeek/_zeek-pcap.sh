#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAP="$1"
OUTPUTDIR="$2"
ZEEKSITE="$3"
LOGFILE="$4"

PCAP="$(FULL_PATH "$PCAP")"
OUTPUTDIR="$(FULL_PATH "$OUTPUTDIR")"
ZEEKSITE="$(FULL_PATH "$ZEEKSITE")"
LOGFILE="$(FULL_PATH "$LOGFILE")"

_TMPDIR=$(MKTEMPDIR "$0" || exit 1)

# Zeek v4.0.4 doesn't support the `LogAscii::logdir` setting; only available on newer versions
# Instead, `pushd` into `_TMPDIR` so the initial Zeek logs get written there. Then, write the
# modified versions back to the provided `OUTPUTDIR`.
# zeek -C -r "$PCAP" LogAscii::json_timestamps=JSON::TS_ISO8601 LogAscii::use_json=T LogAscii::logdir="$_TMPDIR" local

pushd "$_TMPDIR" 2>&1 > /dev/null

CMD="zeek -C -r \"$PCAP\" LogAscii::json_timestamps=JSON::TS_ISO8601 LogAscii::use_json=T \"$ZEEKSITE\""
EXEC_CMD "$CMD" "$LOGFILE"

popd 2>&1 > /dev/null

for _LOG in "$_TMPDIR"/*; do
	if [ -e "$_LOG" ]; then
		_LOG_TYPE="$(STRIP_EXTENSION "$(basename "$_LOG")")"
		cat "$_LOG" | jq -c ". + {event_type: \"$_LOG_TYPE\", pcap_filename: \"$PCAP\"}" >> "$OUTPUTDIR/zeek-$_LOG_TYPE.json"
	fi
done

rm -R "$_TMPDIR"

