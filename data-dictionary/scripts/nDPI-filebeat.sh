#!/usr/bin/env bash

YAML="$1"

echo "- type: log"
echo "  enabled: true"
echo "  fields:"

echo -n "    event_source: "
yq '.event_source' "$YAML" | sed -r 's/^"//; s/"$//'

echo -n "    event_type: "
yq '.event_type' "$YAML" | sed -r 's/^"//; s/"$//'

echo "    incident_number: \"\""
echo "    incident_title: \"\""
echo "    incident_dataset: \"\""
echo "  fields_under_root: true"
echo
echo "  paths:"
echo "    - /data/incidents/[incident_number]/[incident_dataset]/ndpi/*.csv"
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

