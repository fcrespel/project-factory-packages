#!/bin/bash
#
# MySQL Restore Script
# By Fabien CRESPEL <fabien@crespel.net>
#

. "@{product.bin}/loadenv.sh"

BACKUP_DIR="@{package.backup}"


### DO NOT MODIFY BELOW THIS LINE #############################################

FAILURE=0

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup directory ($BACKUP_DIR) is not a valid directory"
	FAILURE=1

else
	DB="$1"
	DATESTRING="$2"
	if [ -n "$DB" ]; then
		ARCHIVE_DIR="$BACKUP_DIR/$DB"
		if [ -e "$ARCHIVE_DIR" ]; then
			if [ -n "$DATESTRING" ]; then
				# Restore backup
				ARCHIVE_NAME=$DB-$DATESTRING.xz
				if [ -e "$ARCHIVE_DIR/$ARCHIVE_NAME" ]; then
					echo "Restoring '$ARCHIVE_NAME' ..."
					if mysql_createdb "$DB" && unxz -c "$ARCHIVE_DIR/$ARCHIVE_NAME" | mysql_exec "$DB"; then
						echo "Backup archive restored successfully"
					else
						echo "ERROR: failed to restore backup archive '$ARCHIVE_NAME'. Make sure mysqld server is running!"
						FAILURE=1
					fi
				else
					echo "ERROR: backup archive '$ARCHIVE_NAME' does not exist"
					FAILURE=1
				fi
			else
				# List backups for DB
				echo "Usage: $0 <db name> <backup archive date>"
				echo "Available backups for database '$DB':"
				ls -1 "$ARCHIVE_DIR" | grep "$DB" | sed -r "s#^$DB-(.*)\\.xz\$#  \\1#g" | sort
			fi
		else
			echo "ERROR: database '$DB' does not exist or has no backup"
			FAILURE=1
		fi
	else
		# List backups
		echo "Usage: $0 <db name> <backup archive date>"
		echo "Available databases:"
		find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -printf '  %f\n' | sort
	fi
fi

exit $FAILURE
