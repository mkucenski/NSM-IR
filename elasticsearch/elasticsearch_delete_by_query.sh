#!/usr/bin/env bash

SOURCE="$1"

curl -X POST "localhost:9200/graylog_0/_delete_by_query?pretty" -H 'Content-Type: application/json' -d"
{
  \"query\": {
    \"match\": {
      \"event_source\": \"$SOURCE\"
    }
  }
}"
curl -X POST "localhost:9200/${SOURCE}_0/_delete_by_query?pretty" -H 'Content-Type: application/json' -d"
{
  \"query\": {
    \"match\": {
      \"event_source\": \"$SOURCE\"
    }
  }
}"
