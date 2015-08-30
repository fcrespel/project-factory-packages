# Interpolate template
interpolatetemplate_inplace "@{package.app}/conf/tomcat-users.xml"
interpolatetemplate_inplace "@{package.data}/hudson.plugins.sonar.SonarPublisher.xml"
interpolatetemplate_inplace "@{package.data}/hudson.plugins.testlink.TestLinkBuilder.xml"
interpolatetemplate_inplace "@{package.data}/org.jenkinsci.plugins.rundeck.RundeckNotifier.xml"
interpolatetemplate_inplace "@{package.data}/users/bot/config.xml"

# Remove proxy config if not used
if [ -z "@{proxy.host}" ]; then
	rm -f "@{package.data}/proxy.xml"
fi

# Fix data directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}"

# Create trust store if necessary
create_truststore "@{package.app}/conf/trust.jks" @{package.user} @{package.group} "@{system.java7.app}/jre/lib/security/cacerts"

# Create symlink in home dir if necessary
if [ ! -e "@{product.root}/.jenkins" -a ! -h "@{product.root}/.jenkins" ]; then
	ln -s "@{package.data}" "@{product.root}/.jenkins" && chown -h @{package.user}:@{package.group} "@{product.root}/.jenkins"
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
	httpd_enable_service jenkins
fi

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Jenkins"
fi
