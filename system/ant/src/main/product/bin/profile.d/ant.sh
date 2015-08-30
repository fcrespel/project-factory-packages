#!/bin/sh
#
# Ant user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

ANT_HOME="@{package.app}"
if [ -e "$ANT_HOME" ]; then
    export PATH="$ANT_HOME/bin:$PATH"
    export ANT_HOME
fi
