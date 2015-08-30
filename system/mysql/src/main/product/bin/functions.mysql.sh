#!/bin/bash
#
# Project Factory - MySQL Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Execute a MySQL command from standard input as the root user (without password)
function mysql_exec_nopw
{
	if [ -z "$MYSQL_SOCKET" ]; then
		printerror "ERROR: MySQL socket path is not defined or is empty"
		return 1
	fi
	mysql --socket=$MYSQL_SOCKET -uroot $@
}

# Execute a MySQL command from standard input as the root user (with password)
function mysql_exec
{
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		printerror "ERROR: MySQL root password is not defined or is empty"
		return 1
	fi
	mysql_exec_nopw -p$MYSQL_ROOT_PASSWORD $@
}

# Check if a MySQL database exists
function mysql_dbexists
{
	local DBNAME="$1"
	echo "show databases like '$DBNAME';" | mysql_exec | grep -q "$DBNAME" > /dev/null 2>&1
}

# Create a MySQL database if it doesn't exist
function mysql_createdb
{
	local DBNAME="$1"
	if ! mysql_dbexists "$DBNAME"; then
		if ! echo "create database \`$DBNAME\` character set utf8;" | mysql_exec; then
			printerror "ERROR: failed to create '$DBNAME' MySQL database"
			return 1
		fi
	fi
}

# Check if a MySQL user exists
function mysql_userexists
{
	local USERNAME="$1"
	echo "select user from mysql.user where user='$USERNAME';" | mysql_exec | grep -q "$USERNAME" > /dev/null 2>&1
}

# Create a MySQL user if it doesn't exist, and optionally grant it all privileges on a database
function mysql_createuser
{
	local USERNAME="$1"
	local PASSWORD="$2"
	local DBNAME="$3"
	if ! mysql_userexists "$USERNAME"; then
		if echo "create user '$USERNAME'@'localhost' identified by '$PASSWORD';" | mysql_exec; then
			if [ -n "$DBNAME" ] && ! echo "grant all privileges on \`$DBNAME\`.* to '$USERNAME'@'localhost';" | mysql_exec; then
				printerror "ERROR: failed to grant privileges to '$USERNAME' MySQL user on database '$DBNAME'"
				return 1
			fi
		else
			printerror "ERROR: failed to create '$USERNAME' MySQL user"
			return 1
		fi
	fi
}
