#!/bin/sh
#
# Sonatype Nexus Backup Script
# By Fabien CRESPEL <fabien@crespel.net>
#

SOURCE_DIR="@{package.data}/"
TARGET_DIR="@{package.backup}/"

if [ -d "$SOURCE_DIR" -a -d "$TARGET_DIR" ]; then
	rsync -rthvzl --delete --exclude='.nexus/trash' "$SOURCE_DIR" "$TARGET_DIR"
fi
