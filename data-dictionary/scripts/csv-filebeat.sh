#!/usr/bin/env bash

YAML="$1"

echo "- type: log"
echo "  enabled: true"
echo "  fields:"

SOURCE="$(yq '.event_source' "$YAML" | sed -r 's/^"//; s/"$//')"
echo "    event_source: $SOURCE"

TYPE="$(yq '.event_type' "$YAML" | sed -r 's/^"//; s/"$//')"
echo "    event_type: $TYPE"

echo "    incident_number: \"\""
echo "    incident_title: \"\""
echo "    incident_dataset: \"\""
echo "  fields_under_root: true"
echo
echo "  paths:"
echo "    - /data/incidents/[incident_number]/[incident_dataset]/$SOURCE/*.csv"
echo
echo "  processors:"
echo "    - decode_csv_fields:"
echo "        fields:"
echo "          message: decode_csv"
echo
echo "    - extract_array:"
echo "        field: decode_csv"
echo "        mappings:"

yq '.event_fields[] | "          " + .standard_name + ": " + (.column | tostring)' "$YAML" | sed -r 's/^"//; s/"$//'

echo
echo "    - timestamp:"
echo "        field: start_time"
echo "        layouts:"
echo "          - \"UNIX\""
echo
echo "    - drop_fields:"
echo "        fields: [ \"decode_csv\", \"message\" ]"
echo "        ignore_missing: true"

