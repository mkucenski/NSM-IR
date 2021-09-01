#!/usr/bin/env bash

YAML_BASE="$1"; shift 1

echo "- type: log"
echo "  enabled: true"
echo "  fields:"

SOURCE="$(yq '.event_source' "$YAML_BASE" | sed -r 's/^"//; s/"$//')"
echo "    event_source: "

echo "    incident_number: \"\""
echo "    incident_title: \"\""
echo "    incident_dataset: \"\""
echo "  fields_under_root: true"
echo "  json.keys_under_root: true"
echo
echo "  paths:"
echo "    - /data/incidents/[incident_number]/[incident_dataset]/suricata/eve-*.json"
echo
echo "  processors:"
echo "    - timestamp:"
echo "        ignore_missing: true"
echo "        ignore_failure: true"
echo "        field: timestamp"
echo "        layouts:"
echo "          - '2006-01-02T15:04:05.999999-0700'"
echo "        test:"
echo "          - '2021-03-01T04:06:12.367451-0800'"
echo "    - drop_fields:"
echo "        fields: ['timestamp']"
echo
echo "    # Common Fields"
echo "    - rename:"
echo "        ignore_missing: true"
echo "        fail_on_error: false"
echo "        fields:"

yq '.event_fields[] | "          - from: \"" + .name + "\"", "            to: \"" + .standard_name + "\""' "$YAML_BASE" | sed -r 's/^"//; s/"$//; s/\\"/"/g'

for YAML_MODULE in $@; do
	TYPE="$(yq '.event_type' "$YAML_MODULE" | sed -r 's/^"//; s/"$//')"
	echo
	echo "    # Module: $TYPE"
	echo "    - add_fields:"
	echo "        when:"
	echo "          has_fields: ['$TYPE']"
#	echo "        target: ''"
	echo "        fields:"
	echo "          event_type: $TYPE"
	echo "    - rename:"
	echo "        when:"
	echo "          has_fields: ['$TYPE']"
	echo "        ignore_missing: true"
	echo "        fail_on_error: false"
	echo "        fields:"

	yq '.event_fields[] | "          - from: \"" + .name + "\"", "            to: \"" + .standard_name + "\""' "$YAML_MODULE" \
	| sed -r 's/^"//; s/"$//; s/\\"/"/g'
done
