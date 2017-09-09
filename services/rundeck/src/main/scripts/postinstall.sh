# Interpolate template
ensurepassword RUNDECK_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"
interpolatetemplate_inplace "@{package.data}/etc/rundeck-config.properties"

# Generate SSH key if necessary
if [ ! -e "@{package.data}/.ssh/id_rsa" ]; then
	mkdir -p "@{package.data}/.ssh"
	ssh-keygen -q -t rsa -C '' -N '' -f "@{package.data}/.ssh/id_rsa"
fi

# Fix data directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"
chmod +x @{package.data}/tools/bin/*

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group} "@{system.java8.app}/jre/lib/security/cacerts"

# Start MySQL if necessary
if ! startservice @{mysql.service}; then
	exit 1
fi

# Create database and user if necessary
if ! mysql_createdb "@{rundeck.db.name}" || ! mysql_createuser "@{rundeck.db.user}" "$RUNDECK_DB_PASSWORD" "@{rundeck.db.name}"; then
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
	httpd_enable_service rundeck
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Rundeck AJP"
	nagios_enable_service "Rundeck HTTP"
fi
