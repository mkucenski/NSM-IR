## NSM-IR - suricata

### Description

### Configuration Notes
- `suricata-update` downloads into `/usr/local/share/suricata/rules/`, but combines into `/var/lib/suricata/rules/suricata.rules`
- Need to re-run `suricata-update` after any changes to /usr/local/share...
- Modified `decoder-events.rules` to disable all "invalid checksum" alerts--generates far too much noise from PCAP captures.

### TODO
- [x] Is disabling the "invalid checksum" alerts the right call or is there a better option?
    - This is a capture issue: https://suricata.readthedocs.io/en/latest/performance/packet-capture.html
    - Ideally, hardware offloading would be disabled on the capture process, but that may not always be the case.
    - Keep these alerts disabled.
