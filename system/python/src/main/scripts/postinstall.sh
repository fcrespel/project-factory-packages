APXS_LIBEXECDIR="@{product.app}/system/httpd/modules"
MOD_WSGI_DIR="$APXS_LIBEXECDIR/mod_wsgi"

# Fix script permissions
chmod +x "$MOD_WSGI_DIR/configure"

# Make and install mod_wsgi
( cd "$MOD_WSGI_DIR" && make distclean ) > /dev/null 2>&1
if ! ( cd "$MOD_WSGI_DIR" && ./configure && make ); then
	printerror "ERROR: failed to compile mod_wsgi"
	exit 1
fi
if ! ( cd "$MOD_WSGI_DIR" && apxs -i -S LIBEXECDIR="$APXS_LIBEXECDIR" -n mod_wsgi src/server/mod_wsgi.la ); then
	printerror "ERROR: failed to install mod_wsgi"
	exit 1
fi
( cd "$MOD_WSGI_DIR" && make distclean ) > /dev/null 2>&1

# Reload HTTPD if already running
reloadservice @{httpd.service}
