#!/usr/bin/env bash

FILE="$1"
OUTPUT=$(echo "$FILE" | sed -r 's/\.gz$//')
echo "$OUTPUT"
gunzip -c "$FILE" > "$OUTPUT"
