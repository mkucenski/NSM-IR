select(has("layers")) | 
	{timestamp: .timestamp} * 
	{communityid: (if .layers.communityid then .layers.communityid else "" end)} * 
	{src_ip: (if .source then .source else "" end)} * 
	{dst_ip: (if .destination then .destination else "" end)} * 
	{protocol: (if .protocol then .protocol else "" end)} * 
	{message: (if .info then .info else "" end)} * 
	.layers.frame * 
	(if .layers.eth then 
		(.layers.eth | if type=="array" then 
			.[0] * (.[1] | with_entries(.key |= "tunnel_" + .)) 
		else . end) 
	else {} end) * 
	(if .layers.ip then 
		(.layers.ip | if type=="array" then 
			.[0] * (.[1] | with_entries(.key |= "tunnel_" + .)) 
		else . end) 
	else {} end)
| del(.ip_host, .ip_addr, .tunnel_ip_host, .tunnel_ip_addr)
