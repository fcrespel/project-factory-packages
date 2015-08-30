#!/bin/bash
#
# Project Factory Setup - LDAP Functions
# By Fabien CRESPEL <fabien@crespel.net>
#

# Get an attribute from the LDAP product database
function ldap_getattr
{
	local FILTER="$1"
	local ATTR="$2"
	ldapsearch -x -H ldap://$LDAP_HOST:$LDAP_PORT -D "$LDAP_ROOTDN" -w "$LDAP_ROOT_PASSWORD" -LLL -b "$LDAP_BASEDN" "$FILTER" "$ATTR" 2>/dev/null | awk -F ': ' "\$1 == \"$ATTR\" {print \$2}"
}

# Add an entry to the LDAP product database
function ldap_add
{
	ldapadd -x -H ldap://$LDAP_HOST:$LDAP_PORT -D "$LDAP_ROOTDN" -w "$LDAP_ROOT_PASSWORD" $@
}

# Modify an entry in the LDAP product database
function ldap_modify
{
	ldapmodify -x -H ldap://$LDAP_HOST:$LDAP_PORT -D "$LDAP_ROOTDN" -w "$LDAP_ROOT_PASSWORD" $@
}

# Modify the RDN of an entry in the LDAP product database
function ldap_modrdn
{
	ldapmodrdn -x -H ldap://$LDAP_HOST:$LDAP_PORT -D "$LDAP_ROOTDN" -w "$LDAP_ROOT_PASSWORD" $@
}
