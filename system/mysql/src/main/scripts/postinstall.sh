MYSQL_VERSION=`@{system.mysql.bin.mysqld} --version`

# Store configuration
storevar MYSQL_SOCKET "@{package.data}/mysql.sock"
storevar MYSQL_CHARSET "@{mysql.charset}"
storevar MYSQL_COLLATION "@{mysql.collation}"

# Fix data and app/run directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"
chown -R @{package.user}:@{package.group} "@{package.app}/run"
chmod +x "@{package.app}/bin/mysqld_safe"

# Enable config options for MySQL 5.5+
if [[ "$MYSQL_VERSION" =~ 5\.[5-9]\. ]]; then
	sed -i 's/^#innodb/innodb/g' "@{package.app}/conf/my.cnf"
fi

# Fill the data directory
if [ ! -e "@{package.data}/mysql" ]; then
	if [[ "$MYSQL_VERSION" =~ 5\.[7-9]\. ]]; then
		rm -f "@{package.data}/.flag"
		if ! @{system.mysql.bin.mysqld} --defaults-file="@{package.app}/conf/my.cnf" --initialize-insecure; then
			printerror "ERROR: failed to initialize MySQL data directory"
			exit 1
		fi
	else
		if ! @{system.mysql.bin}/mysql_install_db --defaults-file="@{package.app}/conf/my.cnf"; then
			printerror "ERROR: failed to initialize MySQL data directory"
			exit 1
		fi
	fi
fi

# Enable service at startup
if ! enableservice @{package.service} reload; then
	exit 1
fi

# Configure root user
ensurepassword MYSQL_ROOT_PASSWORD
if echo "SELECT 1 FROM DUAL;" | mysql_exec_nopw > /dev/null 2>&1; then
	if ! echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD'); FLUSH PRIVILEGES;" | mysql_exec_nopw; then
		printerror "ERROR: failed to set MySQL root password"
		exit 1
	fi
fi

# Configure backup user
ensurepassword MYSQL_BACKUP_PASSWORD
interpolatetemplate_inplace "@{product.bin}/backup.d/backup-mysql.sh"
if ! mysql_userexists "@{mysql.backup.user}"; then
	if ! echo "create user '@{mysql.backup.user}'@'localhost' identified by '$MYSQL_BACKUP_PASSWORD';
	           grant SELECT, LOCK TABLES on *.* to '@{mysql.backup.user}'@'localhost';" | mysql_exec; then
		printerror "ERROR: failed to create MySQL backup user"
		exit 1
	fi
fi

# Configure Nagios user
ensurepassword MYSQL_NAGIOS_PASSWORD
interpolatetemplate_inplace "@{product.data}/admin/nagios/conf.d/mysql.cfg"
if ! mysql_userexists "@{mysql.nagios.user}"; then
	if ! echo "create user '@{mysql.nagios.user}'@'localhost' identified by '$MYSQL_NAGIOS_PASSWORD';
	           grant USAGE on *.* to '@{mysql.nagios.user}'@'localhost';" | mysql_exec; then
		printerror "ERROR: failed to create MySQL Nagios user"
		exit 1
	fi
fi

# Drop anonymous user
echo "DELETE FROM mysql.user WHERE User='';" | mysql_exec > /dev/null 2>&1

# Drop other root users
echo "DELETE FROM mysql.user WHERE User='root' AND Host <> 'localhost';" | mysql_exec > /dev/null 2>&1

# Drop test database and privileges
echo "DROP DATABASE test;" | mysql_exec > /dev/null 2>&1
echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" | mysql_exec > /dev/null 2>&1

# Flush privileges
echo "FLUSH PRIVILEGES;" | mysql_exec > /dev/null 2>&1

# Upgrade tables
@{system.mysql.bin}/mysql_upgrade --defaults-file="@{package.app}/conf/my.cnf" -uroot -p$MYSQL_ROOT_PASSWORD

# Reload Nagios if already running
reloadservice @{nagios.service}
