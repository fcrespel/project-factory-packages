# Interpolate template
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"

# Fix data directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}" "@{package.log}"

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group}

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload HTTPD if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}

# Enable user access to the service
if type -t httpd_enable_service >/dev/null; then
	httpd_enable_service alfresco-solr
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Alfresco Solr AJP"
	nagios_enable_service "Alfresco Solr HTTP"
fi
