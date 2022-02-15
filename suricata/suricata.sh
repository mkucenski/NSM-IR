#!/usr/bin/env bash
. "${BASH_SOURCE%/*}/../../scripts/common-include.sh" || exit 1

PCAPDIR="$1"
OUTPUTDIR="$2"

if [ $# -eq 0 ]; then
	USAGE "PCAPDIR" "OUTPUTDIR"
	USAGE_DESCRIPTION "This script executes Suricata against the specified PCAPDIR and places all log files in OUTPUTDIR."
 	USAGE_EXAMPLE "$(basename "$0") /data/pcap/ /data/suricata/"
	exit 1
fi

PCAPDIR="$(FULL_PATH "$PCAPDIR")"
_YAML="${BASH_SOURCE%/*}/suricata-6x.yaml"
_LOGFILE="$OUTPUTDIR/suricata.log"

START "$0" "$_LOGFILE" "$*"
LOG_VERSION "suricata" "$(suricata -V)" "$_LOGFILE"
LOG "" "$_LOGFILE"

CMD="suricata -c \"$_YAML\" -r \"$PCAPDIR\" -l \"$OUTPUTDIR\""
EXEC_CMD "$CMD" "$_LOGFILE"

CMD="mv \"$OUTPUTDIR/eve-flow.json\" \"$OUTPUTDIR/eve-flow.json.hold\""
EXEC_CMD "$CMD" "$_LOGFILE"
CMD="mv \"$OUTPUTDIR/eve-netflow.json\" \"$OUTPUTDIR/eve-netflow.json.hold\""
EXEC_CMD "$CMD" "$_LOGFILE"

LOG "" "$_LOGFILE"
LOG "BASE64_GZ($_YAML):" "$_LOGFILE"
LOG "$(BASE64_GZ_FILE "$_YAML")" "$_LOGFILE"
END "$0" "$_LOGFILE"


