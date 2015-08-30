# Create the vhosts directory if necessary
if [ ! -e "@{system.httpd.app.vhosts}" ]; then
	mkdir -p "@{system.httpd.app.vhosts}"
	if [ ! -e "@{system.httpd.app.conf}/vhosts.conf" ] && ! grep -q -E -r --include='*.conf' '^\s*Include @{system.httpd.app.vhosts}/\*\.conf' "@{system.httpd.app}" >/dev/null 2>&1; then
		echo 'Include @{system.httpd.app.vhosts}/*.conf' > "@{system.httpd.app.conf}/vhosts.conf"
	fi
fi
