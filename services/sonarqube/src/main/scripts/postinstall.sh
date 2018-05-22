# Prepare passwords
ensurepassword SONARQUBE_DB_PASSWORD
ROOT_PASSWORD_SALT=`genpassword | sha1sum | cut -d' ' -f 1`
ROOT_PASSWORD_SALTED=`echo -n "--$ROOT_PASSWORD_SALT--$ROOT_PASSWORD--" | sha1sum | cut -d' ' -f 1`
BOT_PASSWORD_SALT=`genpassword | sha1sum | cut -d' ' -f 1`
BOT_PASSWORD_SALTED=`echo -n "--$BOT_PASSWORD_SALT--$BOT_PASSWORD--" | sha1sum | cut -d' ' -f 1`
BOT_TOKEN_SHA384=`echo -n "$BOT_PASSWORD_MD5" | sha384sum | cut -d' ' -f 1`

# Interpolate templates
interpolatetemplate_inplace "@{package.app}/conf/sonar.properties"
interpolatetemplate_inplace "@{package.app}/conf/db_overlay.sql"

# Replace application name in startup scripts
sed -i "s#^DEF_APP_NAME=.*#DEF_APP_NAME=\"@{package.service}\"#g" "@{package.app}/bin/linux-x86-32/sonar.sh"
sed -i "s#^DEF_APP_LONG_NAME=.*#DEF_APP_LONG_NAME=\"@{package.service}\"#g" "@{package.app}/bin/linux-x86-32/sonar.sh"
sed -i "s#^DEF_APP_NAME=.*#DEF_APP_NAME=\"@{package.service}\"#g" "@{package.app}/bin/linux-x86-64/sonar.sh"
sed -i "s#^DEF_APP_LONG_NAME=.*#DEF_APP_LONG_NAME=\"@{package.service}\"#g" "@{package.app}/bin/linux-x86-64/sonar.sh"

# Copy bundled plugins
cp @{package.app}/lib/bundled-plugins/*.jar @{package.data}/extensions/plugins/

# Fix permissions
mkdir -p "@{package.app}/elasticsearch/plugins"
chown -R @{package.user}:@{package.group} "@{package.app}" "@{package.data}" "@{package.log}"
chmod +x "@{package.app}/bin/linux-x86-32/wrapper"
chmod +x "@{package.app}/bin/linux-x86-64/wrapper"
chmod +x "@{package.app}/elasticsearch/bin/elasticsearch"
chmod +x "@{package.app}/elasticsearch/bin/elasticsearch-keystore"
chmod +x "@{package.app}/elasticsearch/bin/elasticsearch-plugin"
chmod +x "@{package.app}/elasticsearch/bin/elasticsearch-translog"

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group} "@{system.java8.app}/jre/lib/security/cacerts"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
DO_DBINIT=`if mysql_dbexists "@{sonarqube.db.name}"; then echo 0; else echo 1; fi`
if ! mysql_createdb "@{sonarqube.db.name}" || ! mysql_createuser "@{sonarqube.db.user}" "$SONARQUBE_DB_PASSWORD" "@{sonarqube.db.name}"; then
	exit 1
fi

# Initialize database content
if [ "$DO_DBINIT" -eq 1 ]; then
	# Initialize database
	if ! cat "@{package.app}/conf/db_schema.sql" | mysql_exec "@{sonarqube.db.name}"; then
		printerror "ERROR: failed to initialize SonarQube database"
		exit 1
	fi
	
	# Load default data
	if ! cat "@{package.app}/conf/db_data.sql" | mysql_exec "@{sonarqube.db.name}"; then
		printerror "ERROR: failed to load default data into SonarQube database"
		exit 1
	fi
	
	# Apply SQL overlay
	if ! cat "@{package.app}/conf/db_overlay.sql" | mysql_exec "@{sonarqube.db.name}"; then
		printerror "ERROR: failed to apply overlay to SonarQube database"
		exit 1
	fi
fi

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service sonarqube
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "SonarQube HTTP"
fi
