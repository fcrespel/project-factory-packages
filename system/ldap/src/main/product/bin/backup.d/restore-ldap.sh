#!/bin/bash
#
# LDAP Restore Script
# By Fabien CRESPEL <fabien@crespel.net>
#

BACKUP_DIR="@{package.backup}"

SLAPADD="@{system.openldap.bin.slapadd}"

SLAPD_CONF_DIR="@{package.app}/conf.d"
SLAPD_DATA_DIR="@{package.data}"
SLAPD_USER="@{package.user}"
SLAPD_GROUP="@{package.group}"
BASEDN="@{ldap.base.dn}"


### DO NOT MODIFY BELOW THIS LINE #############################################

FAILURE=0

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup directory ($BACKUP_DIR) is not a valid directory"
	FAILURE=1

else
	DATESTRING="$1"
	ARCHIVE_DIR="$BACKUP_DIR/$BASEDN"
	if [ -n "$DATESTRING" ]; then
		# Restore backup
		ARCHIVE_NAME=$BASEDN-$DATESTRING.xz
		if [ -e "$ARCHIVE_DIR/$ARCHIVE_NAME" ]; then
			echo "Restoring '$ARCHIVE_NAME' ..."
			if unxz -c "$ARCHIVE_DIR/$ARCHIVE_NAME" | $SLAPADD -c -F "$SLAPD_CONF_DIR" -b "$BASEDN"; then
				chown -R $SLAPD_USER:$SLAPD_GROUP "$SLAPD_DATA_DIR"
				echo "Backup archive restored successfully"
			else
				echo "ERROR: failed to restore backup archive '$ARCHIVE_NAME'. Make sure slapd server is stopped!"
				FAILURE=1
			fi
		else
			echo "ERROR: backup archive '$ARCHIVE_NAME' does not exist"
			FAILURE=1
		fi
	else
		# List backups
		echo "Usage: $0 <backup archive date>"
		echo "Available backups:"
		ls -1 "$ARCHIVE_DIR" | grep "$BASEDN" | sed -r "s#^$BASEDN-(.*)\\.xz\$#  \\1#g" | sort
	fi
fi

exit $FAILURE
