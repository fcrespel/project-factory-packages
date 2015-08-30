#!/bin/bash
#
# Subversion Repository post-creation script
# By Fabien CRESPEL <fabien@crespel.net>
#


# Script variables
SVN_DIR="@{package.app}"
AUTHZ_FILE="@{package.data}/authz"
HTTPD_USER="@{httpd.user}"
HTTPD_GROUP="@{httpd.group}"
PRODUCT_GROUP_ADMINS="@{product.group.admins}"

# Check and print syntax
if [ $# -lt 1 ]; then
	echo "Usage: $0 <repo path> [repo type] [project id]"
	exit 1
fi

# Get repository path
REPO_PATH="$1"
REPO_NAME=`basename "$REPO_PATH"`
if [ ! -e "$REPO_PATH" ]; then
	echo "Repository '$REPO_PATH' does not exist"
	exit 1
fi

# Add a pre-commit hook
echo "Adding pre-commit hook ..."
cat << EOF > "$REPO_PATH/hooks/pre-commit"
#!/bin/sh
"$SVN_DIR/run-hooks.sh" pre-commit "\$@"
EOF
chmod +x "$REPO_PATH/hooks/pre-commit"

# Add a post-commit hook
echo "Adding post-commit hook ..."
cat << EOF > "$REPO_PATH/hooks/post-commit"
#!/bin/sh
"$SVN_DIR/run-hooks.sh" post-commit "\$@"
exit 0
EOF
chmod +x "$REPO_PATH/hooks/post-commit"

# Fix permissions
echo "Setting file owner and permissions ..."
chown -R $HTTPD_USER:$HTTPD_GROUP "$REPO_PATH"
chmod -R g+w "$REPO_PATH"

# Create the project groups in authz
if ! grep -q "prj-${REPO_NAME}" "$AUTHZ_FILE"; then
	echo "Adding project group to authz ..."
	sed -i '
/^### INSERT NEW GROUPS HERE/ i\
prj-'$REPO_NAME' = 
' "$AUTHZ_FILE"
fi

# Add repo permissions in authz
if ! grep -q "\[${REPO_NAME}:/\]" "$AUTHZ_FILE"; then
	echo "Adding default permissions to authz ..."
	sed -i '
/^### INSERT NEW REPOSITORIES HERE/ i\
\
['$REPO_NAME':/]\
* = \
@sys-ro = r\
@sys-rw = rw\
@'$PRODUCT_GROUP_ADMINS' = rw\
@prj-'$REPO_NAME' = rw\

' "$AUTHZ_FILE"
fi

exit 0
