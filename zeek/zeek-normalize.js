function process(event) {
	var zeek_ts = parseFloat(event.Get("ts"));
	if (zeek_ts) {
		var zeek_date = new Date(Math.floor(zeek_ts*1000));
		event.Put("zeek_timestamp", zeek_date);
	}

	var zeek_log = event.Get("log.file.path");
	if (zeek_log) {
		var zeek_type = zeek_log.split('/');
		event.Put("zeek_log_type", zeek_type[zeek_type.length-1]);
	}
}

