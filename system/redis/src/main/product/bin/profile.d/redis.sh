#!/bin/sh
#
# Redis user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

REDIS_HOME="@{package.app}"
if [ -e "$REDIS_HOME" ]; then
    export PATH="$REDIS_HOME/bin:$PATH"
fi
