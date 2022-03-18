#!/usr/bin/env bash
IFS=$(echo -en "\n\b")

# Generate a YAML template from CSV samples. Header line is pulled from CSV for parsing. 
# NAMEMAP is a csv mapping 'name' tl 'standard_name' (e.g. 'Source IP,src_ip').

# This allows a new template to easily be generated from a new CSV or update a CSV whose
# headers/fields/columns might change.

# 'csv-filebeat.sh' can then be used to generate a filebeat input module from this YAML
# template (from the CSV metadata).

CSV="$1"
NAMEMAP="$2"

echo "title:"
echo "description:"
echo "platform:"
echo ""
echo "event_source:"
echo "event_type:"
echo "event_version: '0'"
echo ""
echo "event_fields:"
echo "# standard_type: "integer, long, float, double, string, boolean, or ip" (based on filebeat types)"
echo ""

# Pull the first line from the CSV and map column number to column name (e.g. '8,Source IP')
HEADERS=$(csvquote "$CSV" | head -n 1 | sed -r 's/\r//; s/, ?/\n/g' | nl -v 0 -ba | sed -r 's/^[[:space:]]+([[:digit:]]+)[[:space:]]+/\1,/' | csvquote -u -r '\n')

# For each header entry, retrieve the new 'standard_name' from NAMEMAP and output the
# YAML entry.
for HEADER in $HEADERS; do
	COLUMN=$(echo "$HEADER" | cut -d "," -f 1)
	NAME=$(echo "$HEADER" | cut -d "," -f 2)
	STDNAME=$(egrep "^$NAME," "$NAMEMAP" | cut -d "," -f 2)
	echo "- standard_name: $STDNAME"
	echo "  standard_type:"
	echo "  column: $COLUMN"
	echo "  name: $NAME"
	echo "  type:"
	echo "  description:"
	echo "  sample_value:"
	echo ""
done

echo "references:"
echo "- text:"
echo "  link:"
echo "tags: []"
