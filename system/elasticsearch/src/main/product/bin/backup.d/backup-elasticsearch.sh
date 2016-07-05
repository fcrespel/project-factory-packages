#!/bin/bash
#
# Elasticsearch Backup Script
# By Fabien CRESPEL <fabien@crespel.net>
#

ES_PORT="@{package.port.http}"
ES_BACKUP_DIR="@{package.backup}"
ES_REPO_NAME="backup"
ES_SNAPSHOT_NAME="backup_$(date --rfc-3339=date)"

# Check availability
if curl -fsS -XGET "http://127.0.0.1:$ES_PORT" > /dev/null 2>&1; then
	# Create repository
	if ! curl -fsS -XPUT "http://127.0.0.1:$ES_PORT/_snapshot/$ES_REPO_NAME" -d "{
		\"type\": \"fs\",
		\"settings\": {
			\"location\": \"$ES_BACKUP_DIR\",
			\"compress\": true
		}
	}" > /dev/null; then
		echo "ERROR: failed to create Elasticsearch backup repository in '$ES_BACKUP_DIR'"
		exit 1
	fi
	
	# Create snapshot
	if ! curl -fsS -XPUT "http://127.0.0.1:$ES_PORT/_snapshot/$ES_REPO_NAME/$ES_SNAPSHOT_NAME" > /dev/null; then
		echo "ERROR: failed to create Elasticsearch snapshot '$ES_SNAPSHOT_NAME'"
		exit 2
	fi
fi
