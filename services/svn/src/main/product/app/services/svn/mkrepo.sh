#!/bin/bash
#
# Subversion Repository creation script
# By Fabien CRESPEL <fabien@crespel.net>
#


# Script variables
SCRIPT_DIR=`dirname $0`
REPOS_DIR="@{package.data}/repos"
REPOS_URL="@{product.scheme}://@{product.domain}/svn"
SVNADMIN="/usr/bin/svnadmin"
SVN="/usr/bin/svn"

# Check and print syntax
if [ $# -lt 1 ]; then
	echo "Usage: $0 <repo name>"
	exit 1
fi

# Get repository name
REPO_NAME="$1"
REPO_PATH="$REPOS_DIR/$REPO_NAME"
if [ -e "$REPO_PATH" ]; then
	echo "Repository '$REPO_NAME' already exists"
	exit 1
fi

# Create the repository
echo "Creating repository '$REPO_NAME' ..."
$SVNADMIN create "$REPO_PATH"

# Call post-create script
"$SCRIPT_DIR/mkrepo-post-create.sh" "$REPO_PATH" "svn" "$REPO_NAME"

# Create initial directory structure
echo "Creating initial directory structure ..."
REPO_URL="$REPOS_URL/$REPO_NAME"
$SVN mkdir $REPO_URL/trunk $REPO_URL/branches $REPO_URL/tags -m "Create initial directory structure"

exit 0
