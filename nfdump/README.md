## NSM-IR - nfdump
- https://github.com/phaag/nfdump

### Description

### FreeBSD
- Port has to be recompiled to support reading .pcap files.
  - Make fails if `bison` has been compiled with 'NLS' support...
  - Recompile `bison` w/o NLS support, then `nfdump` will compile w/.pcap support.
