# NSM-IR

## Description
- Graylog
	- Elasticsearch
	- Filebeat
	- MongoDB
- Suricata (5.x for FreeBSD)
- Zeek (formerly known as Bro)
- nDPI
- nfdump (compiled to support reading from pcap files)
- Wireshark

## Configuration Notes

## TODO
- [ ] Normalize data fields
- [ ] Lookups for standard ports
- [ ] Lookup for TCP flag values
-
- [ ] Tunnel/GRE Analysis Options
- [ ] Ethernet/MAC mapping to IP
- [ ] Broad CommunityID Support
- [ ] Athena DNS Records
-
- [ ] Automation based on file closing/copying to trigger all modules

- Efficiency:
  - [ ] Drop fields that aren't relevant

- Other Ideas:
  - [ ] Need a way to categorize IPs (at least): Private network, DoD, Root DNS servers; things that are generally known.
  - [ ] It would also be interesting to distinguish between "in/around" my network and "outside" my network.

