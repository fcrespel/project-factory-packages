#!/bin/bash
#
# Project Factory - Apache HTTPD Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Disable access to a service and show a maintenance page
function httpd_disable_service
{
	local SERVICE="$1"
	[ -n "$SERVICE" ] && touch "@{package.app}/run/maintenance/$SERVICE"
}

# Enable access to a service
function httpd_enable_service
{
	local SERVICE="$1"
	[ -n "$SERVICE" ] && rm -f "@{package.app}/run/maintenance/$SERVICE"
}

# Disable access to the entire platform and show a maintenance page
function httpd_disable_platform
{
	touch "@{system.httpd.app.vhosts}/${PRODUCT_ID}.maintenance"
}

# Enable access to the entire platform
function httpd_enable_platform
{
	rm -f "@{system.httpd.app.vhosts}/${PRODUCT_ID}.maintenance"
}
