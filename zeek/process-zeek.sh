#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAP_DIR="$1"
OUTPUT_DIR="$2"

if [ $# -eq 0 ]; then
	USAGE "PCAP_DIR" "OUTPUT_DIR"
	USAGE_DESCRIPTION "This script executes Zeek in standalone/PCAP mode and slightly modified the logs for easier input into Graylog."
 	USAGE_EXAMPLE "$(basename "$0") /data/pcaps /data/zeek"
	exit 1
fi

BASENAME="$(STRIP_EXTENSION "$(basename "$0")")_$(DATE)"
LOGFILE="$(FULL_PATH "$OUTPUT_DIR")/$BASENAME.log"
START "$0" "$LOGFILE" "$*"

LOG_VERSION "zeek" "$(zeek --version)" "$LOGFILE"

_TMPDIR=$(MKTEMPDIR "$0" || exit 1)

# Zeek v4.0.4 doesn't support the `LogAscii::logdir` setting; only available on newer versions
# Instead, `pushd` into `_TMPDIR` so the initial Zeek logs get written there. Then, write the
# modified versions back to the provided `OUTPUT_DIR`.
PCAP_DIR="$(FULL_PATH "$PCAP_DIR")"
OUTPUT_DIR="$(FULL_PATH "$OUTPUT_DIR")"
pushd "$_TMPDIR" 2>&1 > /dev/null

for PCAP in $(find "$PCAP_DIR" -type f); do
	echo "$PCAP"

	# Zeek v4.0.4 doesn't support the `LogAscii::logdir` setting; only available on newer versions
	# zeek -C -r "$PCAP" LogAscii::json_timestamps=JSON::TS_ISO8601 LogAscii::use_json=T LogAscii::logdir="$_TMPDIR" local
	CMD="zeek -C -r \"$PCAP\" LogAscii::json_timestamps=JSON::TS_ISO8601 LogAscii::use_json=T local"
	EXEC_CMD "$CMD" "$LOGFILE"

	for LOG in "$_TMPDIR"/*; do
		if [ -e "$LOG" ]; then
			LOG_TYPE="$(STRIP_EXTENSION "$(basename "$LOG")")"
			cat "$LOG" | jq -c ". + {event_type: \"$LOG_TYPE\", pcap_filename: \"$PCAP\"}" >> "$OUTPUT_DIR/zeek-$LOG_TYPE.json"
		fi
	done

	rm "$_TMPDIR"/* 2>&1 > /dev/null
done

popd 2>&1 > /dev/null
rm -R "$_TMPDIR"

END "$0" "$LOGFILE"

