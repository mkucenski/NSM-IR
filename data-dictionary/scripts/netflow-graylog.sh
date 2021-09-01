#!/usr/bin/env bash

YAML="$1"

echo "rule \"normalize_netflow\""
echo "when"
echo "  true"
echo "then"

yq '.event_fields[] | "  rename_field(\"" + .graylog_name + "\", \"" + .standard_name + "\");"' "$YAML" | sed -r 's/^"//; s/"$//; s/\\"/"/g'

echo "end"
