RUBY_GEMS="@{ruby.gems}"

# Prepare/fix RVM
storevar RVM_DIR "@{package.app}/rvm"
find "@{package.app}/rvm/bin" -type f -exec chmod +x '{}' \;
find "@{package.app}/rvm/scripts" -type f -exec chmod +x '{}' \;
rvm_quiet autolibs read-fail
rvm_quiet repair symlinks

# Install Ruby and gems
for RUBY_VERSION in @{ruby.versions}; do
	# Install Ruby
	if ! rvm install "$RUBY_VERSION" --disable-binary --rubygems ignore; then
		printerror "ERROR: failed to install Ruby $RUBY_VERSION"
		exit 1
	fi
	# Create alias
	if ! rvm alias create "${RUBY_VERSION%.*}.x" "$RUBY_VERSION"; then
		printerror "ERROR: failed to create alias for Ruby version $RUBY_VERSION"
		exit 1
	fi
	# Install gems
	if ! installgems "$RUBY_VERSION" "$RUBY_GEMS"; then
		exit 1
	fi
done
rvm_quiet cleanup sources

# Create default alias
if ! rvm alias create default @{ruby.default.version}; then
	printerror "ERROR: failed to set default Ruby version to @{ruby.default.version}"
	exit 1
fi

# Check if 'passenger-config' is available
PASSENGER_CONFIG=`rvm default do which passenger-config`
if [ ! -x "$PASSENGER_CONFIG" ]; then
	printerror "ERROR: the 'passenger-config' command is not available or not executable"
	exit 1
fi

# Check if 'passenger-install-apache2-module' is available
PASSENGER_INSTALL=`rvm default do which passenger-install-apache2-module`
if [ ! -x "$PASSENGER_INSTALL" ]; then
	printerror "ERROR: the 'passenger-install-apache2-module' command is not available or not executable"
	exit 1
fi

# Install Passenger Apache module (if necessary)
PASSENGER_ROOT=`rvm default do passenger-config --root`
PASSENGER_MODULE="$PASSENGER_ROOT/buildout/apache2/mod_passenger.so"
if [ ! -e "$PASSENGER_MODULE" ]; then
	if ! rvm default do passenger-install-apache2-module -a PASSENGER_DOWNLOAD_NATIVE_SUPPORT_BINARY=0; then
		printerror "ERROR: failed to install Phusion Passenger's Apache module"
		exit 1
	fi
fi

# Interpolate Passenger configuration
interpolatetemplate_inplace "@{product.app}/system/httpd/conf.d/mod_passenger.conf"

# Fix permissions
chown -R @{package.user}:@{package.group} "@{package.app}/rvm"
chmod -R g+w "@{package.app}/rvm"

# Reload HTTPD if already running
reloadservice @{httpd.service}
