# Interpolate template
ensurepassword ALFRESCO_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"
interpolatetemplate_inplace "@{package.app}/shared/classes/alfresco-global.properties"

# Fix permissions
chown -R @{package.user}:@{package.group} "@{package.data}"
chmod +x @{package.app}/bin/*

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group} "@{system.java8.app}/jre/lib/security/cacerts"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
if ! mysql_createdb "@{alfresco.db.name}" || ! mysql_createuser "@{alfresco.db.user}" "$ALFRESCO_DB_PASSWORD" "@{alfresco.db.name}"; then
	exit 1
fi

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload HTTPD if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service alfresco-platform
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Alfresco Platform AJP"
	nagios_enable_service "Alfresco Platform HTTP"
fi
