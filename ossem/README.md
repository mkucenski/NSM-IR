# `yq` parsing examples:
- Select OSSEM-DD `standard_name` field based on `name` field to pull mappings
	- cat eve.yml | yq '.event_fields[] | select(.name == "dest_port") | .name + "," + .standard_name'
	- cat eve.yml | yq '.event_fields[] | .name + "," + .standard_name'


