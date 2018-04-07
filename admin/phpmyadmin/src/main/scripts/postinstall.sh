PMA_BLOWFISH_SECRET=`genpassword 32`
ensurepassword PMA_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/config.inc.php"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
if ! mysql_createdb "@{pma.db.name}" || ! mysql_createuser "@{pma.db.user}" "$PMA_DB_PASSWORD" "@{pma.db.name}"; then
	exit 1
fi

# Initialize database tables
if ! cat "@{package.app}/sql/create_tables.sql" | sed "s#phpmyadmin#@{pma.db.name}#g" | mysql_exec; then
	printerror "ERROR: failed to initialize '@{pma.db.name}' database"
	exit 1
fi

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service phpmyadmin
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "phpMyAdmin"
fi
