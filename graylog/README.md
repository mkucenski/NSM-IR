## NSM-IR - graylog
- https://graylog.org

### Description

### Dependencies
- `pwgen`
- `elasticsearch`
- `mongodb`

### Configuration Notes
- Indices
	- Indexes setup to contain analysis data need to be changed from the default of rotate/delete to rotate/close.
		- https://www.graylog.org/post/log-indexing-and-rotation-for-optimized-archival-in-graylog
		- "Close: Closing an index, blocks Elasticsearch from writing more data into it, but keeps it online and maintains the index’s metadata so you can still search it."
		- This prevents graylog from periodically purging "old" records.
	- From an efficiency standpoing, it may make sense to index based on the "event_type" fields so that all DNS records are in one index, all flows in another, etc.
		- That could speed up searching by automatically allowing you to narrow the focus to only events of interest.
		- With "only" 0.5 billion records, searching slows to a crawl...
		- Indexing by incident/dataset may also be a good choice to limit data, but that's only if you're working with more than one incident at a time.

- Configuration
	- 'Pipeline Processor' needs to come *after* 'Message Filter Chain' or the renaming rules don't work.

### TODO
- [ ] Stream routing should be automated based on the following (potentially): Incident, Dataset, Event Source.
	- Messages can be assigned multiple streams; effectively tagging them. These tags are more quickly queried than standard message queries and should speed up searching.
- [ ] Indexes probably don't matter then and all Streams can be backed by one index.
	- Alternatively, indexes could be done per incident with stream routing then only for incident/dataset--that's probably easier since it allows you to drop entire incidents once no longer needed for analysis.
	- Unfortunately, that then requires complex stream + indices to be created/modified as we go. Backing everything in one index set and tagging by only event source and incident means you only have to create a few streams and the pipeline rules can handle the routing automatically. Doing anything else is going to results in a pretty complicated web of streams, indices, etc and will be pretty difficult to avoid creating duplicate entries.
- [ ] Need a way to categorize IPs (at least): Private network, DoD, Root DNS servers; things that are generally known.
- [ ] It would also be interesting to distinguish between "in/around" my network and "outside" my network.
	
