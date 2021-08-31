# `yq` parsing examples:
- Select OSSEM-DD `standard_name` field based on `name` field to pull mappings
	- cat eve.yml | yq '.event_fields[] | select(.name == "dest_port") | .name + "," + .standard_name'
	- cat eve.yml | yq '.event_fields[] | .name + "," + .standard_name'
	- `'.event_fields[] | "- from: \"" + .name + "\"", "  to: \"" + .standard_name + "\""'`
	- "\"has_fields: ['\" + .event_code + \"']\""

- nDPI:
	- '.event_fields[] | "          " + .standard_name + ": " + (.column | tostring)'

## TODO
- Zeek has lots of geoip fields that need to be normalized.
- zeek snmp is broken
- no packet_filter dd
- weird is missing definitions...
- Suricata uses `event_type` for the type of log entry; zeek-normalize.js needs to match
-
