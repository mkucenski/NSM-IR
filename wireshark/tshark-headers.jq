select(has("layers")) | 
	{timestamp: .timestamp} * 
	{communityid: (if .layers.communityid then .layers.communityid else "" end)} * 
	{src_ip: (if .source then .source else "" end)} * 
	{src_port: (if .srcport then .srcport else "" end)} * 
	{dst_ip: (if .destination then .destination else "" end)} * 
	{dst_port: (if .dstport then .dstport else "" end)} * 
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

