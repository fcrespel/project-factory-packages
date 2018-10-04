APXS="@{system.httpd.bin.apxs}"
APXS_LIBEXECDIR="@{package.app}/modules"
MOD_AUTH_CAS_DIR="$APXS_LIBEXECDIR/mod_auth_cas"

# Fix permissions
chown -R @{package.user}:@{package.group} "@{package.data}/mod_auth_cas"
chmod +x "$MOD_AUTH_CAS_DIR/compile"
chmod +x "$MOD_AUTH_CAS_DIR/config.guess"
chmod +x "$MOD_AUTH_CAS_DIR/config.sub"
chmod +x "$MOD_AUTH_CAS_DIR/configure"
chmod +x "$MOD_AUTH_CAS_DIR/depcomp"
chmod +x "$MOD_AUTH_CAS_DIR/install-sh"
chmod +x "$MOD_AUTH_CAS_DIR/missing"

# Make and install mod_auth_cas
sed -i 's#SSL_library_init#SSL_CTX_new#g' "$MOD_AUTH_CAS_DIR/configure.ac" "$MOD_AUTH_CAS_DIR/configure"
( cd "$MOD_AUTH_CAS_DIR" && make distclean ) > /dev/null 2>&1
if ! ( cd "$MOD_AUTH_CAS_DIR" && autoreconf -ivf && ./configure && make ); then
	printerror "ERROR: failed to compile mod_auth_cas"
	exit 1
fi
if ! ( cd "$MOD_AUTH_CAS_DIR" && $APXS -i -S LIBEXECDIR="$APXS_LIBEXECDIR" src/mod_auth_cas.la ); then
	printerror "ERROR: failed to install mod_auth_cas"
	exit 1
fi
( cd "$MOD_AUTH_CAS_DIR" && make distclean ) > /dev/null 2>&1

# Initialize logs
for LOGFILE in access_log error_log; do
	touch "@{package.log}/$LOGFILE" && chown @{package.user}:@{package.group} "@{package.log}/$LOGFILE"
done

# Create self-signed certificate if necessary
if [ ! -e "@{package.app}/ssl/servercert.pem" ]; then
	# Generate a new certificate
	if ! openssl req -x509 -nodes -days 3652 \
		-subj "/C=FR/O=@{product.name}/CN=@{product.domain}" \
		-newkey rsa:2048 -sha256 -keyout "@{package.app}/ssl/serverkey.pem" -out "@{package.app}/ssl/servercert.pem" > /dev/null 2>&1; then
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
	a2enmod ssl proxy proxy_http proxy_ajp proxy_wstunnel headers rewrite version > /dev/null 2>&1
fi
if which a2ensite > /dev/null 2>&1; then
	a2ensite "@{product.id}.conf" > /dev/null 2>&1
fi

# Enable service at startup
if ! enableservice @{package.service} restart; then
	exit 1
fi

# Reload system HTTPD and Nagios if already running
reloadservice @{system.httpd.service}
reloadservice @{nagios.service}
