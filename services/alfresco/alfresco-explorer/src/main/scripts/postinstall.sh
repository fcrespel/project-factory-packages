# Interpolate template
ensurepassword ALFRESCO_DB_PASSWORD
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"
interpolatetemplate_inplace "@{package.app}/shared/classes/alfresco-global.properties"
interpolatetemplate_inplace "@{package.app}/shared/classes/alfresco/extension/subsystems/Authentication/ldap/ldap1/ldap-authentication.properties"

# Fix data directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"

# Fix SWFTools script permissions
chmod +x "@{package.app}/swftools/src/config.guess"
chmod +x "@{package.app}/swftools/src/configure"
chmod +x "@{package.app}/swftools/src/install-sh"
chmod +x "@{package.app}/swftools/src/missing"
chmod +x "@{package.app}/swftools/src/mkinstalldirs"

# Make and install SWFTools
( cd "@{package.app}/swftools/src" && make distclean ) > /dev/null 2>&1
if ! ( cd "@{package.app}/swftools/src" && ./configure --prefix=@{package.app}/swftools ); then
	printerror "ERROR: failed to configure SWFTools"
	exit 1
fi
if ! ( cd "@{package.app}/swftools/src" && make ); then
	printerror "ERROR: failed to compile SWFTools"
	exit 1
fi
if ! ( cd "@{package.app}/swftools/src" && make install ); then
	printerror "ERROR: failed to install SWFTools"
	exit 1
fi
( cd "@{package.app}/swftools/src" && make distclean ) > /dev/null 2>&1

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group}

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
	httpd_enable_service alfresco-explorer
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Alfresco Explorer"
fi
