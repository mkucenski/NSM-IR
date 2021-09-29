## NSM-IR - filebeat
- https://www.elastic.co/guide/en/beats/filebeat/current/index.html

### Description

### Dependencies

### Configuration Notes

#### file_identity.inode_marker.path:
- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-log.html
- By default, filebeat uses a device ID + inode to determine whether a log file has been processed. However, the device ID can be unreliable and changed after reboots causing the files to get reprocessed. Using the following log setting on the inputs should correct the issue:
    - file_identity.inode_marker.path: /logs/.filebeat-marker
    - The file needs to be populated with a unique identifier to prevent..
        - Linux:    `lsblk -o MOUNTPOINT,UUID | grep /logs | awk '{print $2}' >> /logs/.filebeat-marker`
        - FreeBSD:  `gpart list da0 | grep rawuuid | sed -r 's/^.*: (.+)$/\1/' >> /logs/.filebeat-marker`

### TODO
- Instead of rename for normalizing, it would be better to `convert` in order to do type validation at the same time:
    - https://www.elastic.co/guide/en/beats/filebeat/current/convert.html
