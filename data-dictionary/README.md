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

## NetFlow
- Has the concept of 'input' and 'output' as it relates to bytes/packets. (when it comes to bidirectional flows; uni only uses in_bytes/packets):
  - "IN_BYTES - Incoming counter with length N x 8 bits for number of bytes associated with an IP Flow."
  - "OUT_BYTES - Outgoing counter with length N x 8 bits for the number of bytes associated with an IP Flow"
  - From testing a sample download (370M disk image download):
    - Internal-to-External Flow:
			- "src4_addr": "192.168.1.187"
			- "dst4_addr": "149.20.1.200"
			- "in_packets": 153,470
			- "in_bytes": 5,206,831
		- External-to-Internal Flow:
			- "src4_addr": "149.20.1.200",
			- "dst4_addr": "192.168.1.187",
			- "in_packets": 268,136
			- "in_bytes": 396,830,042
  - **"IN" seems to be the bytes/packets going "into" the destination device.**
  - When combined into a bidirectional flow (aggregated):
    - "src4_addr": "192.168.1.187"
  	- "dst4_addr": "149.20.1.200"
  	- "in_packets": 153,470
  	- "in_bytes": 5,206,831
  	- "out_bytes": 396,830,042
  	- "out_packets": 268,136
  - **"IN" seems to be the bytes/packets going -> in -> the destination device and -> out -> of the source device.**
    - `in_bytes` & `in_packets` should be assigned `src_bytes` and `src_packets` as they are those coming from/owned by the src device (while being sent to the dest device).
    - In this case, unidirectional flows will always assign the bytes/packets to the src device. I think that makes sense as the src is the start of the flow.
  - **"OUT" seems to be the bytes/packet going <- out <- the destination device and <- in the <- source device.**
    - `out_bytes` & `out_packets` should be assigned `dst_bytes` and `dst_packets` as they are those coming from/owned by the dest device (while being sent back to the src device).



	- 'input' seems to be bytes/packets coming into the src device
	- 'output' seems to be bytes/packets coming out of the src device
