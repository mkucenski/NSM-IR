function process(event) {
	var zeek_ts = parseFloat(event.Get("ts"));
	if (zeek_ts) {
		// Zeek is using a float value of seconds since the
		// unix epoch (e.g. 1614599948.342959). Flattening to
		// the integer value will lose granularity; instead
		// convert to milliseconds and return the integer
		// The resulting 'timestamp' should be convertable
		// using 'UNIX_MS' and the filebeat 'timestamp'
		// processor.
		var zeek_timestamp = Math.round(zeek_ts*1000);
		event.Put("timestamp", zeek_timestamp);
	}

	var zeek_log = event.Get("log.file.path");
	if (zeek_log) {
		// Split based on path, use only the filename, and
		// and remove the trailing '.log' leaving: 'conn',
		// 'dhcp', etc. Insert as 'event_type' to match
		// Suricata assignment for 'anomaly', 'alert', etc.
		var zeek_log_path = zeek_log.split('/');
		var zeek_log_type = zeek_log_path[zeek_log_path.length-1];
		event.Put("event_type", zeek_log_type.substring(0, zeek_log_type.length - 4));
	}
}

