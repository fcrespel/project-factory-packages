ensurepassword PIWIK_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/config/config.ini.php"
interpolatetemplate_inplace "@{package.app}/config/init.sql"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
DO_DBINIT=`if mysql_dbexists "@{piwik.db.name}"; then echo 0; else echo 1; fi`
if ! mysql_createdb "@{piwik.db.name}" || ! mysql_createuser "@{piwik.db.user}" "$PIWIK_DB_PASSWORD" "@{piwik.db.name}"; then
	exit 1
fi

# Initialize database content
if [ "$DO_DBINIT" -eq 1 ]; then
	if ! cat "@{package.app}/config/init.sql" | mysql_exec "@{piwik.db.name}"; then
		printerror "ERROR: failed to create Piwik tables in '@{piwik.db.name}' database"
		exit 1
	fi
fi

# Update database (twice for certain versions)
if ! /usr/bin/php "@{package.app}/console" core:update --yes; then
	exit 1
fi
if ! /usr/bin/php "@{package.app}/console" core:update --yes; then
	exit 1
fi

# Clear cache
/usr/bin/php "@{package.app}/console" core:clear-caches > /dev/null 2>&1

# Fix data and config directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}" "@{package.app}/config"
chmod -R ug=rwX "@{package.data}" "@{package.app}/config"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service piwik
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Piwik"
fi

# Enable cron job
rm -f "@{product.bin}/cron.hourly/piwik-archive.sh.lock"
