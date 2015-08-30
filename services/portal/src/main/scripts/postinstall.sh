# Set default theme
if [ -z "$PRODUCT_THEME" ]; then
	storevar PRODUCT_THEME basic
fi
rm -f "@{package.app}/themes/default" && ln -s "$PRODUCT_THEME" "@{package.app}/themes/default"

# Fix permissions
chown -h @{product.user}:@{product.group} "@{package.app}/themes/default"
chown @{package.user}:@{package.group} "@{package.app}/themes"
chmod ug=rwX "@{package.app}/themes"

# Reload HTTPD and Nagios if already running
reloadservice @{httpd.service}
reloadservice @{nagios.service}
