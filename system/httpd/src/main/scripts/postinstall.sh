# Initialize logs
for LOGFILE in access_log error_log; do
	touch "@{package.log}/$LOGFILE" && chown @{package.user}:@{package.group} "@{package.log}/$LOGFILE"
done

# Create self-signed certificate if necessary
if [ ! -e "@{package.app}/ssl/servercert.pem" ]; then
	# Generate a new certificate
	if ! openssl req -x509 -nodes -days 3652 \
		-subj "/C=FR/O=@{product.name}/CN=@{product.domain}" \
		-newkey rsa:1024 -keyout "@{package.app}/ssl/serverkey.pem" -out "@{package.app}/ssl/servercert.pem" > /dev/null 2>&1; then
		printerror "ERROR: failed to generate a self-signed certificate for @{product.domain}"
		exit 1
	fi
	
	# Adjust permissions
	chown @{package.user}:@{package.group} "@{package.app}/ssl/serverkey.pem" "@{package.app}/ssl/servercert.pem"
	chmod 600 "@{package.app}/ssl/serverkey.pem"
	chmod 644 "@{package.app}/ssl/servercert.pem"
fi

# Ensure a certificate chain file is present
if [ ! -e "@{package.app}/ssl/cacert.pem" ]; then
	ln -s "servercert.pem" "@{package.app}/ssl/cacert.pem"
	chown -h @{package.user}:@{package.group} "@{package.app}/ssl/cacert.pem"
fi

# Configure system HTTPD
if which a2enmod > /dev/null 2>&1; then
	a2enmod ssl proxy proxy_http proxy_ajp headers version > /dev/null 2>&1
fi
if which a2ensite > /dev/null 2>&1; then
	a2ensite "@{product.id}.conf" > /dev/null 2>&1
fi

# Enable service at startup
if ! enableservice @{package.service} reload; then
	exit 1
fi

# Reload system HTTPD and Nagios if already running
reloadservice @{system.httpd.service}
reloadservice @{nagios.service}
