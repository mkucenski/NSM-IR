#!/usr/bin/env bash

YAML_BASE="$1"; shift 1

echo "- type: log"
echo "  enabled: true"
echo "  fields:"

SOURCE="$(yq '.event_source' "$YAML_BASE" | sed -r 's/^"//; s/"$//')"
echo "    event_source: $SOURCE"

echo "    incident_number: \"\""
echo "    incident_title: \"\""
echo "    incident_dataset: \"\""
echo "  fields_under_root: true"
echo "  json.keys_under_root: true"
echo
echo "  paths:"
echo "    - /data/incidents/[incident_number]/[incident_dataset]/zeek/*/*.log"
echo
echo "  processors:"
echo "    - script:"
echo "        lang: javascript"
echo "        id: zeek-normalize"
echo "        file: \${path.config}/scripts/zeek-normalize.js"
echo
echo "    - timestamp:"
echo "        field: timestamp"
echo "        layouts:"
echo "          - \"UNIX_MS\""
echo
echo "    - drop_fields:"
echo "        fields: timestamp"
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
	echo "    - rename:"
	echo "        when:"
	echo "          equals:"
	echo "            event_type: $TYPE"
	echo "        ignore_missing: true"
	echo "        fail_on_error: false"
	echo "        fields:"

	yq '.event_fields[] | "          - from: \"" + .name + "\"", "            to: \"" + .standard_name + "\""' "$YAML_MODULE" \
	| sed -r 's/^"//; s/"$//; s/\\"/"/g'
done
