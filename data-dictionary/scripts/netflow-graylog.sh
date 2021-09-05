#!/usr/bin/env bash

YAML="$1"

echo "rule \"normalize_netflow\""
echo "when"
echo "  has_field(\"nf_src\")"
echo "then"
echo "  set_field(\"event_source\", \"netflow\");"
echo "  set_field(\"event_type\", \"flow\");"
echo
echo "  set_field(\"incident_number\", \"\");"
echo "  set_field(\"incident_title\", \"\");"
echo "  set_field(\"incident_dataset\", \"\");"
echo

yq '.event_fields[] | "  rename_field(\"" + .graylog_name + "\", \"" + .standard_name + "\");"' "$YAML" | sed -r 's/^"//; s/"$//; s/\\"/"/g'

echo "end"
