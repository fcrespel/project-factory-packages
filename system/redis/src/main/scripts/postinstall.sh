# Fix script permissions
chmod +x "@{package.app}/src/deps/jemalloc/bin/pprof"
chmod +x "@{package.app}/src/deps/jemalloc/config.guess"
chmod +x "@{package.app}/src/deps/jemalloc/config.sub"
chmod +x "@{package.app}/src/deps/jemalloc/configure"
chmod +x "@{package.app}/src/deps/jemalloc/install-sh"

# Make and install
POSTINSTALL_OUTPUT=`mktemp --tmpdir=$PRODUCT_TMP`
( cd "@{package.app}/src" && make distclean ) > /dev/null 2>&1
if ! ( cd "@{package.app}/src" && make ) > "$POSTINSTALL_OUTPUT" 2>&1; then
	cat "$POSTINSTALL_OUTPUT"
	rm -f "$POSTINSTALL_OUTPUT"
	printerror "ERROR: failed to compile Redis"
	exit 1
fi
if ! ( cd "@{package.app}/src" && make PREFIX="@{package.app}" install ) > "$POSTINSTALL_OUTPUT" 2>&1; then
	cat "$POSTINSTALL_OUTPUT"
	rm -f "$POSTINSTALL_OUTPUT"
	printerror "ERROR: failed to install Redis"
	exit 1
fi
( cd "@{package.app}/src" && make distclean ) > /dev/null 2>&1
rm -f "$POSTINSTALL_OUTPUT"

# Fix data and log directory permissions
chown -R @{package.user}:@{package.group} "@{package.data}" "@{package.log}"

# Enable service at startup
if ! enableservice @{package.service}; then
	exit 1
fi

# Reload Nagios if already running
reloadservice @{nagios.service}

# Enable Nagios monitoring
if type -t nagios_enable_service >/dev/null; then
	nagios_enable_service "Redis"
fi
