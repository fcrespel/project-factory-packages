#!/bin/bash
#
# Project Factory - MySQL Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Execute a MySQL command from standard input as the root user (without password)
function mysql_exec_nopw
{
	@{system.mysql.bin}/mysql --defaults-file="$PRODUCT_APP/system/mysql/conf/my.cnf" -uroot $@
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

# Upgrade a MySQL database's storage engine and encoding
function mysql_upgradedb
{
	local DBNAME="$1"
	if [ -z "$MYSQL_CHARSET" ]; then
		MYSQL_CHARSET="utf8"
	fi
	if [ -z "$MYSQL_COLLATION" ]; then
		MYSQL_COLLATION="${MYSQL_CHARSET}_general_ci"
	fi
	if ! ( echo "SELECT CONCAT('ALTER TABLE \`', TABLE_NAME,'\` ENGINE=InnoDB;') AS 'Statements' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DBNAME}' AND TABLE_TYPE='BASE TABLE';" | mysql_exec | tail -n +2 ) | mysql_exec "${DBNAME}"; then
		printerror "ERROR: failed to set ENGINE=InnoDB for '$DBNAME' MySQL database"
		return 1
	fi
	if ! ( echo "SELECT CONCAT('ALTER TABLE \`', TABLE_NAME,'\` ROW_FORMAT=DYNAMIC;') AS 'Statements' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DBNAME}' AND TABLE_TYPE='BASE TABLE' AND ROW_FORMAT!='Dynamic';" | mysql_exec | tail -n +2 ) | mysql_exec "${DBNAME}"; then
		printerror "ERROR: failed to set ROW_FORMAT=DYNAMIC for '$DBNAME' MySQL database"
		return 1
	fi
	if ! ( echo "SET foreign_key_checks = 0;"; echo "SELECT CONCAT('ALTER TABLE \`', TABLE_NAME,'\` CONVERT TO CHARACTER SET ${MYSQL_CHARSET} COLLATE ${MYSQL_COLLATION};') AS 'Statements' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='${DBNAME}' AND TABLE_COLLATION!='${MYSQL_COLLATION}' AND TABLE_TYPE='BASE TABLE';" | mysql_exec | tail -n +2; echo "SET foreign_key_checks = 1;" ) | mysql_exec "${DBNAME}"; then
		printerror "ERROR: failed to convert tables to '$MYSQL_CHARSET' charset for '$DBNAME' MySQL database"
		return 1
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
