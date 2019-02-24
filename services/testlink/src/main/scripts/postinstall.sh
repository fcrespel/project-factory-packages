# Interpolate templates
ensurepassword TESTLINK_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/config_db.inc.php"
interpolatetemplate_inplace "@{package.app}/custom_config.inc.php"
interpolatetemplate_inplace "@{package.app}/install/sql/overlay.sql"

# Fix data and log directory permissions
chown -R @{httpd.user}:@{httpd.group} "@{package.app}" "@{package.data}" "@{package.log}"

# Initialize logs
touch "@{package.log}/ldap_sync.log" && chown @{product.user}:@{product.group} "@{package.log}/ldap_sync.log"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
DO_DBINIT=`if mysql_dbexists "@{testlink.db.name}"; then echo 0; else echo 1; fi`
if ! mysql_createdb "@{testlink.db.name}" || ! mysql_createuser "@{testlink.db.user}" "$TESTLINK_DB_PASSWORD" "@{testlink.db.name}"; then
	exit 1
fi

# Initialize database content
if [ "$DO_DBINIT" -eq 1 ]; then
	# Create tables
	if ! cat "@{package.app}/install/sql/mysql/testlink_create_tables.sql" | mysql_exec "@{testlink.db.name}"; then
		printerror "ERROR: failed to create TestLink tables in '@{testlink.db.name}' database"
		exit 1
	fi
	if ! cat "@{package.app}/install/sql/mysql/testlink_create_udf0.sql" | sed 's#YOUR_TL_DBNAME#@{testlink.db.name}#g' | mysql_exec "@{testlink.db.name}"; then
		printerror "ERROR: failed to create TestLink functions in '@{testlink.db.name}' database"
		exit 1
	fi
	
	# Fill tables with default data
	if ! cat "@{package.app}/install/sql/mysql/testlink_create_default_data.sql" | mysql_exec "@{testlink.db.name}"; then
		printerror "ERROR: failed to fill TestLink tables in '@{testlink.db.name}' database"
		exit 1
	fi
	
	# Apply SQL overlay
	if ! interpolatetemplate "@{package.app}/install/sql/overlay.sql" | mysql_exec "@{testlink.db.name}"; then
		printerror "ERROR: failed to apply overlay to TestLink MySQL database"
		exit 1
	fi
else
	# Migrate database
	TESTLINK_DB_VERSION=`echo "select replace(max(version), ' ', '.') from db_version" | mysql_exec -B -N "@{testlink.db.name}"`
	if [ -n "$TESTLINK_DB_VERSION" ]; then
		find "@{package.app}/install/sql/alter_tables" -type d -wholename '*/mysql/*' -name 'DB.*' -printf '%%P\n' | sort -t '/' -k 3,3 -V | while read DIRNAME; do
			INSTALL_DB_VERSION=`echo "$DIRNAME" | cut -d'/' -f 3`
			if [ "$INSTALL_DB_VERSION" != "`echo -e "$TESTLINK_DB_VERSION\n$INSTALL_DB_VERSION" | sort -V | head -n1`" ]; then
				find "@{package.app}/install/sql/alter_tables/$DIRNAME" -name '*.sql' -printf '%%P\n' | sort -t '/' -k 1,1 -k 2,2 -V | while read FILENAME; do
					if ! cat "@{package.app}/install/sql/alter_tables/$DIRNAME/$FILENAME" | sed 's#YOUR_TL_DBNAME#@{testlink.db.name}#g' | mysql_exec "@{testlink.db.name}"; then
						printerror "ERROR: failed to migrate TestLink database '@{testlink.db.name}' to version $INSTALL_DB_VERSION"
						exit 1
					fi
				done
				sleep 1 # Sleep to avoid identical timestamps in db_version
			fi
		done
	fi
fi

# Delete install folder
rm -Rf "@{package.app}/install"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service testlink
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "TestLink"
fi

# Enable cron job
if type -t cron_enable_job >/dev/null; then
	cron_enable_job "@{product.bin}/cron.5mins/testlink-ldap-sync.sh"
fi
