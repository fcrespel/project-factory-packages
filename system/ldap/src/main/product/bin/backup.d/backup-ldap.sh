#!/bin/bash
#
# LDAP Backup Script
# By Fabien CRESPEL <fabien@crespel.net>
#

MAX_BACKUPS=30

BACKUP_DIR="@{package.backup}"
TMP_DIR=`mktemp -d --tmpdir=@{product.tmp}`

SLAPCAT=/usr/sbin/slapcat

SLAPD_CONF_DIR="@{package.app}/conf.d"
BASEDN_LIST="@{ldap.base.dn}"


### DO NOT MODIFY BELOW THIS LINE #############################################

FAILURE=0

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup directory ($BACKUP_DIR) is not a valid directory"
	FAILURE=1

elif [ ! -d "$TMP_DIR" ]; then
	echo "Temp directory ($TMP_DIR) is not a valid directory"
	FAILURE=1

else
	for BASEDN in $BASEDN_LIST; do
	
		# Find a suitable archive name
		DATESTRING=`date +"%Y%m%dT%H%M%S"`
		ARCHIVE_DIR="$BACKUP_DIR/$BASEDN"
		ARCHIVE_NAME=$BASEDN-$DATESTRING.xz
		mkdir -p "$ARCHIVE_DIR"
		
		NUMBER=2
		while [ -e "$ARCHIVE_DIR/$ARCHIVE_NAME" ] ; do
			ARCHIVE_NAME=$BASEDN-$DATESTRING-$NUMBER.xz
			NUMBER=`expr $NUMBER + 1`
		done
		
		# Create backup archive
		echo "Backing up '$BASEDN' ..."
		if $SLAPCAT -F "$SLAPD_CONF_DIR" -b "$BASEDN" | xz > "$TMP_DIR/$ARCHIVE_NAME" ; then
			if touch "$ARCHIVE_DIR/$ARCHIVE_NAME" && cp "$TMP_DIR/$ARCHIVE_NAME" "$ARCHIVE_DIR/$ARCHIVE_NAME"; then
				rm -f "$TMP_DIR/$ARCHIVE_NAME"
				NUMBER=1
				ls -1 -t $ARCHIVE_DIR/$BASEDN-* | while read BACKUPFILE ; do
					if [ "$NUMBER" -gt "$MAX_BACKUPS" ] ; then
						rm -f "$BACKUPFILE"
					fi
					NUMBER=`expr $NUMBER + 1`
				done
			else
				echo "ERROR: failed to copy backup archive '$ARCHIVE_NAME' to '$ARCHIVE_DIR' for root DN '$BASEDN' (exit code: $?)"
				rm -f "$TMP_DIR/$ARCHIVE_NAME"
				FAILURE=1
			fi
		else
			echo "ERROR: failed to create backup archive '$TMP_DIR/$ARCHIVE_NAME' for root DN '$BASEDN' (exit code: $?)"
			rm -f "$TMP_DIR/$ARCHIVE_NAME"
			FAILURE=1
		fi
	done
fi

if [ -e "$TMP_DIR" ]; then
	rm -Rf "$TMP_DIR"
fi

exit $FAILURE
