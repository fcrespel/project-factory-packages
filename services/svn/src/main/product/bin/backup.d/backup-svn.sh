#!/bin/bash
#
# Subversion Repository Backup Script
# By Fabien CRESPEL <fabien@crespel.net>
#

MAX_BACKUPS=10

BACKUP_DIR="@{package.backup}"
REPOS_DIR="@{package.data}/repos"
TMP_DIR=`mktemp -d --tmpdir=@{product.tmp}`

EXCLUDE="test sandbox"


### DO NOT MODIFY BELOW THIS LINE #############################################

FAILURE=0

if [ ! -d "$BACKUP_DIR" ]; then
	echo "Backup directory ($BACKUP_DIR) is not a valid directory"
	FAILURE=1

elif [ ! -d "$REPOS_DIR" ]; then
	echo "Repository directory ($REPOS_DIR) is not a valid directory"
	FAILURE=1

elif [ ! -d "$TMP_DIR" ]; then
	echo "Temp directory ($TMP_DIR) is not a valid directory"
	FAILURE=1

else
	REPOS_LIST=`find "$REPOS_DIR" -mindepth 1 -maxdepth 1 -type d`
	
	echo "$REPOS_LIST" | while read REPO_DIR ; do
		if [ -z "$REPO_DIR" ]; then
			continue;
		fi
		
		REPO=`basename "$REPO_DIR"`
		REV=`svnlook youngest "$REPO_DIR"`
		
		ISEXCLUDED=0
		for EXCL in $EXCLUDE ; do
			if [ "$REPO" = "$EXCL" ] ; then
				ISEXCLUDED=1
			fi
		done
		if [ $ISEXCLUDED -eq 1 ] ; then
			continue
		fi
		
		echo "Backing up repository '$REPO' at revision $REV..."
		ARCHIVE_DIR="$BACKUP_DIR/$REPO"
		ARCHIVE_NAME=$REPO-$REV.tar.bz2
		mkdir -p "$ARCHIVE_DIR"
		if [ -e "$ARCHIVE_DIR/$ARCHIVE_NAME" ] ; then
			echo "Repository '$REPO' already backed up at revision $REV, ignoring."
		else
			if tar -cj -f "$TMP_DIR/$ARCHIVE_NAME" -C "$REPOS_DIR" "$REPO" ; then
				if touch "$ARCHIVE_DIR/$ARCHIVE_NAME" && cp "$TMP_DIR/$ARCHIVE_NAME" "$ARCHIVE_DIR/$ARCHIVE_NAME"; then
					rm -f "$TMP_DIR/$ARCHIVE_NAME"
					NUMBER=1
					ls -1 -t $ARCHIVE_DIR/$REPO-* | while read BACKUPFILE ; do
						if [ "$NUMBER" -gt "$MAX_BACKUPS" ] ; then
							rm -f "$BACKUPFILE"
						fi
						NUMBER=`expr $NUMBER + 1`
					done
				else
					echo "ERROR: failed to copy backup archive '$ARCHIVE_NAME' to '$ARCHIVE_DIR' for repository '$REPO' (exit code: $?)"
					rm -f "$TMP_DIR/$ARCHIVE_NAME"
					FAILURE=1
				fi
			else
				echo "ERROR: failed to create backup archive '$TMP_DIR/$ARCHIVE_NAME' for repository '$REPO' (exit code: $?)"
				rm -f "$TMP_DIR/$ARCHIVE_NAME"
				FAILURE=1
			fi
		fi
	done
fi

if [ -e "$TMP_DIR" ]; then
	rm -Rf "$TMP_DIR"
fi

exit $FAILURE
