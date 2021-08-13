## NSM-IR - graylog
- https://graylog.org

### Description

### Configuration Notes
- Indices
	- Indexes setup to contain analysis data need to be changed from the default of rotate/delete to rotate/close.
		- https://www.graylog.org/post/log-indexing-and-rotation-for-optimized-archival-in-graylog
		- "Close: Closing an index, blocks Elasticsearch from writing more data into it, but keeps it online and maintains the index’s metadata so you can still search it."
		- This prevents graylog from periodically purging "old" records.
