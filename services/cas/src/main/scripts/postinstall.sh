# Generate encryption keys
[ -z "$CAS_REGISTRY_ENCRYPTION_KEY" ] && storevar CAS_REGISTRY_ENCRYPTION_KEY "$(cat /dev/urandom | head -c 16 | base64 -w 0 | tr '+/' '-_')"
[ -z "$CAS_REGISTRY_SIGNING_KEY" ] && storevar CAS_REGISTRY_SIGNING_KEY "$(cat /dev/urandom | head -c 64 | base64 -w 0 | tr '+/' '-_')"
[ -z "$CAS_TGC_ENCRYPTION_KEY" ] && storevar CAS_TGC_ENCRYPTION_KEY "$(cat /dev/urandom | head -c 32 | base64 -w 0 | tr '+/' '-_')"
[ -z "$CAS_TGC_SIGNING_KEY" ] && storevar CAS_TGC_SIGNING_KEY "$(cat /dev/urandom | head -c 64 | base64 -w 0 | tr '+/' '-_')"
[ -z "$CAS_WEBFLOW_ENCRYPTION_KEY" ] && storevar CAS_WEBFLOW_ENCRYPTION_KEY "$(cat /dev/urandom | head -c 16 | base64 -w 0 | tr '+/' '-_')"
[ -z "$CAS_WEBFLOW_SIGNING_KEY" ] && storevar CAS_WEBFLOW_SIGNING_KEY "$(cat /dev/urandom | head -c 64 | base64 -w 0 | tr '+/' '-_')"

# Interpolate templates
ensurepassword CAS_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"
interpolatetemplate_inplace "@{package.app}/webapps/@{project.artifactId}/WEB-INF/classes/application.yml"

# Fix permissions
chown -R @{package.user}:@{package.group} "@{package.data}" "@{package.log}"

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group}

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
	nagios_enable_service "CAS AJP"
	nagios_enable_service "CAS HTTP"
fi
