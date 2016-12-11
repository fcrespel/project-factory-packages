#!/bin/sh
#
# Git user profile configuration.
# By Fabien CRESPEL <fabien@crespel.net>
#

GIT_HOME="@{package.app}"
if [ -e "$GIT_HOME" ]; then
    export PATH="$GIT_HOME/bin:$PATH"
fi
