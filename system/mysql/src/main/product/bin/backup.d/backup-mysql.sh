#!/bin/bash
#
# MySQL Backup Script
# By Fabien CRESPEL <fabien@crespel.net>
#

MAX_BACKUPS=30

BACKUP_DIR="@{package.backup}"
TMP_DIR=`mktemp -d --tmpdir=@{product.tmp}`

MYSQLSHOW=/usr/bin/mysqlshow
MYSQLDUMP=/usr/bin/mysqldump

MYSQL_SOCKET="@{package.data}/mysql.sock"
MYSQL_USER="@{mysql.backup.user}"
MYSQL_PW="%{MYSQL_BACKUP_PASSWORD}"

DB_EXCLUDE="test information_schema"


### DO NOT MODIFY BELOW THIS LINE #############################################

FAILURE=0

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup directory ($BACKUP_DIR) is not a valid directory"
	FAILURE=1

elif [ ! -d "$TMP_DIR" ]; then
	echo "Temp directory ($TMP_DIR) is not a valid directory"
	FAILURE=1

else
	DB_LIST=`$MYSQLSHOW --socket=$MYSQL_SOCKET -u$MYSQL_USER -p$MYSQL_PW | tail -n+4 | head -n-1 | cut -d' ' -f2`
	
	for DB in $DB_LIST ; do
		ISEXCLUDED=0
		for EXCL in $DB_EXCLUDE ; do
			if [ "$DB" = "$EXCL" ] ; then
				ISEXCLUDED=1
			fi
		done
		if [ $ISEXCLUDED -eq 1 ] ; then
			continue
		fi
		
		# Find a suitable archive name
		DATESTRING=`date +"%Y%m%dT%H%M%S"`
		ARCHIVE_DIR="$BACKUP_DIR/$DB"
		ARCHIVE_NAME=$DB-$DATESTRING.xz
		mkdir -p "$ARCHIVE_DIR"
		
		NUMBER=2
		while [ -e "$ARCHIVE_DIR/$ARCHIVE_NAME" ] ; do
			ARCHIVE_NAME=$DB-$DATESTRING-$NUMBER.xz
			NUMBER=`expr $NUMBER + 1`
		done
		
		# Create backup archive
		echo "Backing up '$DB' ..."
		if $MYSQLDUMP -c --opt --socket=$MYSQL_SOCKET -u$MYSQL_USER -p$MYSQL_PW $DB | xz > "$TMP_DIR/$ARCHIVE_NAME" ; then
			if touch "$ARCHIVE_DIR/$ARCHIVE_NAME" && cp "$TMP_DIR/$ARCHIVE_NAME" "$ARCHIVE_DIR/$ARCHIVE_NAME"; then
				rm -f "$TMP_DIR/$ARCHIVE_NAME"
				NUMBER=1
				ls -1 -t $ARCHIVE_DIR/$DB-* | while read BACKUPFILE ; do
					if [ "$NUMBER" -gt "$MAX_BACKUPS" ] ; then
						rm -f "$BACKUPFILE"
					fi
					NUMBER=`expr $NUMBER + 1`
				done
			else
				echo "ERROR: failed to copy backup archive '$ARCHIVE_NAME' to '$ARCHIVE_DIR' for database '$DB' (exit code: $?)"
				rm -f "$TMP_DIR/$ARCHIVE_NAME"
				FAILURE=1
			fi
		else
			echo "ERROR: failed to create backup archive '$TMP_DIR/$ARCHIVE_NAME' for database '$DB' (exit code: $?)"
			rm -f "$TMP_DIR/$ARCHIVE_NAME"
			FAILURE=1
		fi
	done
fi

if [ -e "$TMP_DIR" ]; then
	rm -Rf "$TMP_DIR"
fi

exit $FAILURE
