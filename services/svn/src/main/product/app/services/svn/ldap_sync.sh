#!/bin/bash
#
# Subversion LDAP sync exec script.
# By Fabien CRESPEL <fabien@crespel.net>
#

# Script variables
SCRIPT_DIR=`dirname $0`
AUTHZ_FILE="@{package.data}/authz"
PYTHON="/usr/bin/python"

LDAP_URL="ldap://@{ldap.host}:@{ldap.port}"
LDAP_BASEDN="@{ldap.base.dn}"
LDAP_BIND_DN="@{ldap.root.dn}"
LDAP_BIND_PW="%{LDAP_ROOT_PASSWORD}"
GROUP_FILTER="objectClass=@{ldap.group.class}"
GROUP_MEMBER="@{ldap.group.member.attr}"
USER_FILTER="objectClass=@{ldap.user.class}"
USER_UID="@{ldap.user.rdn.attr}"

# Sync with LDAP
$PYTHON "$SCRIPT_DIR/ldap_sync.py" \
	-l "$LDAP_URL" -d "$LDAP_BIND_DN" -p "$LDAP_BIND_PW" -b "$LDAP_BASEDN" \
	-g "$GROUP_FILTER" -m "$GROUP_MEMBER" -u "$USER_FILTER" -i "$USER_UID" \
	-z "$AUTHZ_FILE"

# Check for missing groups
GROUPS_DEF=`mktemp`
GROUPS_REF=`mktemp`
sed -e '1,/^\[groups\]/d' -e '/^\[.*\]/,$d' "$AUTHZ_FILE" | grep -o '^[a-zA-Z0-9][^ =]*' | sort | uniq > "$GROUPS_DEF"
grep -o '^@[^ =]*' "$AUTHZ_FILE" | cut -c 2- | sort | uniq > "$GROUPS_REF"
comm -13 "$GROUPS_DEF" "$GROUPS_REF" | while read GROUP_NAME; do
	echo "Adding missing group '$GROUP_NAME' to authz."
	sed -i '
/^### INSERT NEW GROUPS HERE/ i\
'$GROUP_NAME' = 
' "$AUTHZ_FILE"
done
rm -f "$GROUPS_DEF" "$GROUPS_REF"
