PYTHON_EGGS_DIR="@{product.app}/system/python/eggs"
PYTHON_MODULES="@{osqa.python.modules}"

# Interpolate templates
ensurepassword OSQA_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/settings_local.py"
interpolatetemplate_inplace "@{package.app}/tmp/overlay.sql"

# Install Python modules
if ! easy_install -H None -f "$PYTHON_EGGS_DIR" $PYTHON_MODULES; then
	printerror "ERROR: failed to install required Python modules"
	exit 1
fi

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
DO_DBINIT=`if mysql_dbexists "@{osqa.db.name}"; then echo 0; else echo 1; fi`
if ! mysql_createdb "@{osqa.db.name}" || ! mysql_createuser "@{osqa.db.user}" "$OSQA_DB_PASSWORD" "@{osqa.db.name}"; then
	exit 1
fi

# Initialize or migrate database
if [ "$DO_DBINIT" -eq 1 ]; then
	# Create tables and fill with default data
	if ! python "@{package.app}/manage.py" syncdb --all --noinput; then
		printerror "ERROR: failed to initialize OSQA database"
		exit 1
	fi
	
	# Initialize South migrations
	if ! python "@{package.app}/manage.py" migrate forum --fake; then
		printerror "ERROR: failed to initialize OSQA migrations"
		exit 1
	fi
	
	# Install MySQL fulltext index
	if ! cat "@{package.app}/forum_modules/mysqlfulltext/fts_install.sql" | mysql_exec "@{osqa.db.name}"; then
		printerror "ERROR: failed to install fulltext index on OSQA database"
		exit 1
	fi
	
	# Apply SQL overlay
	if ! cat "@{package.app}/tmp/overlay.sql" | mysql_exec "@{osqa.db.name}"; then
		printerror "ERROR: failed to apply overlay to OSQA database"
		exit 1
	fi
else
	# Migrate database structure
	if ! python "@{package.app}/manage.py" migrate forum; then
		printerror "ERROR: failed to migrate OSQA database"
		exit 1
	fi
fi

# Cleanup
rm -Rf "@{package.app}/cache"
find "@{package.app}" -name '*.pyc' -exec rm -f '{}' \;
touch "@{package.log}/django.osqa.log"
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}/upfiles" "@{package.log}/django.osqa.log"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service osqa
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "OSQA"
fi

# Enable cron job
rm -f "@{product.bin}/cron.daily/osqa-notifications.sh.lock"
