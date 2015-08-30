#!/bin/bash
#
# LDAP user renaming script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Shared routines
. "@{product.bin}/loadenv.sh"

# Script variables
RENAME_FROM="$1"
RENAME_TO="$2"
LDAP_USERS_DN="@{ldap.users.dn}"
LDAP_USER_RDN_ATTR="@{ldap.user.rdn.attr}"
LDAP_USER_CN_ATTR="@{ldap.user.commonname.attr}"

# Check arguments
if [ -z "$RENAME_FROM" -o -z "$RENAME_TO" ]; then
	echo "Usage: $0 <source username> <target username>"
	exit 1
fi

# Modify the user's RDN (refint overlay takes care of references in groups)
if ldap_modrdn -r "$LDAP_USER_RDN_ATTR=$RENAME_FROM,$LDAP_USERS_DN" "$LDAP_USER_RDN_ATTR=$RENAME_TO" ; then
	# Modify the user's Common Name
	cat <<-EOF | ldap_modify
	dn: $LDAP_USER_RDN_ATTR=$RENAME_TO,$LDAP_USERS_DN
	changetype: modify
	replace: $LDAP_USER_CN_ATTR
	$LDAP_USER_CN_ATTR: $RENAME_TO
	-
EOF
fi
