## NSM-IR - wireshark (tshark)

### Description

### Dependencies

### Configuration Notes

#### `tshark` JSON/Elasticsearch Output Bug
- `tshark` has a small bug where the Elasticsearch output (`-T ek`) outputs keys named as: "frame_frame_..." or "eth_eth_...".
- This is due to a bug in their code, that I've corrected in my local copy of wireshark (patch-epan_print.c).
- It's fairly trivial to work around this bug since most of what gets manipulated/input into Graylog is renamed anyway.
