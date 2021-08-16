# `yq` parsing examples:
- Select OSSEM-DD `standard_name` field based on `name` field to pull mappings
- matthew.kucenski@Matts-MacBook-Pro suricata % clear; yq e '.event_fields.[] | select (.name =="timestamp") | .standard_name' eve.yml

