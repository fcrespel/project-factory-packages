# Store configuration
storevar NAGIOS_CMD "@{package.data}/cmd/nagios.cmd"

# Create sudoers config
SUDOERS_FILE="@{system.sudo.data}/@{product.id}"
[ -e "$SUDOERS_FILE" ] || touch "$SUDOERS_FILE"
if ! grep -q "Defaults:@{package.user}" "$SUDOERS_FILE"; then
	echo "Defaults:@{package.user} !requiretty" >> "$SUDOERS_FILE"
fi

# Allow executing the check_updates plugin as root
if ! grep -q "@{package.user}.*check_updates" "$SUDOERS_FILE"; then
	echo "@{package.user} ALL= NOPASSWD: @{system.nagios.app.plugins}/@{system.nagios.cmd.check_updates.bin}" >> "$SUDOERS_FILE"
fi

# Allow executing the restart-service event handler as root
if ! grep -q "@{package.user}.*restart-service" "$SUDOERS_FILE"; then
	echo "@{package.user} ALL= NOPASSWD: @{package.app}/eventhandlers/restart-service.sh" >> "$SUDOERS_FILE"
fi

# Fix data directory and sudoers file permissions
chown -R @{package.user}:@{package.group} "@{package.data}"
chmod 0440 "$SUDOERS_FILE"

# Enable service at startup
if ! enableservice @{package.service} reload; then
	exit 1
fi

# Reload HTTPD if already running
reloadservice @{httpd.service}
