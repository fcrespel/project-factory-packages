# Create the vhosts directory if necessary
mkdir -p "@{system.httpd.app.vhosts}"

# Include vhosts config files if necessary
if [ -z "@{system.httpd.app.vhosts.enabled}" ]; then
	if [ ! -e "@{system.httpd.app.conf}/vhosts.conf" ] && ! grep -q -E -r --include='*.conf' '^\s*Include(Optional)? @{system.httpd.app.vhosts}/\*\.conf' "@{system.httpd.app}" >/dev/null 2>&1; then
		echo 'Include @{system.httpd.app.vhosts}/*.conf' > "@{system.httpd.app.conf}/vhosts.conf"
	fi
fi
