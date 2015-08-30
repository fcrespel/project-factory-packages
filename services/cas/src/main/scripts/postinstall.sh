# Interpolate template
ensurepassword CAS_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"
interpolatetemplate_inplace "@{package.app}/webapps/cas/WEB-INF/cas.properties"

# Create mod_auth_cas cookie directory
mkdir -p "@{product.data}/system/httpd/mod_auth_cas"
chown -R @{httpd.user}:@{httpd.group} "@{product.data}/system/httpd/mod_auth_cas"

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group}

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
if ! mysql_createdb "@{cas.db.name}" || ! mysql_createuser "@{cas.db.user}" "$CAS_DB_PASSWORD" "@{cas.db.name}"; then
	exit 1
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
	httpd_enable_service cas
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "CAS"
fi
