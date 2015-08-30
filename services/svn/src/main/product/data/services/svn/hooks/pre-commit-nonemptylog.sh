#!/bin/sh
# Non-empty log message check hook

REPOS="$1"
TXN="$2"
SVNLOOK=/usr/bin/svnlook

MSG="Vous devez entrer un message de journal pour cette revision"

# Make sure that the log message contains some text.
if ! ( $SVNLOOK log -t "$TXN" "$REPOS" | grep "[a-zA-Z0-9]" > /dev/null ); then
	echo "$MSG" >&2
	exit 1
fi

# All checks passed, so allow the commit.
exit 0
