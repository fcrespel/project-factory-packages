#!/bin/sh
#
# Go user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

GOROOT="@{package.app}"
if [ -e "$GOROOT" ]; then
    export PATH="$GOROOT/bin:$PATH"
fi
