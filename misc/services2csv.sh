#!/usr/bin/env bash

SERVICES="/home/matthew.kucenski/Development/GitHub/nmap/nmap/nmap-services"

cat "$SERVICES" | grep -v "^#" | cut -f 1-2 | sed -r 's/([[:space:]]+|\/)/,/g' | awk 'BEGIN {FS=","; OFS=","} {print $2, $1}' | sort -nu
