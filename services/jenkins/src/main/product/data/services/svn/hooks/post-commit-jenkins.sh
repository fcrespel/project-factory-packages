#!/bin/sh
# Jenkins commit notification hook

. "@{product.bin}/loadenv.sh"

REPOS="$1"
REV="$2"
UUID=`svnlook uuid $REPOS`
CHANGES=`svnlook changed --revision $REV $REPOS`

JENKINS_URL="@{product.scheme}://$PRODUCT_DOMAIN/jenkins"
TOKEN_URL="$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"
NOTIFY_URL="$JENKINS_URL/subversion/$UUID/notifyCommit?rev=$REV"

echo "Obtaining CSRF token ..."
CSRF_HEADER=""
CSRF_TOKEN=`/usr/bin/wget -q --auth-no-challenge --http-user="$BOT_USER" --http-passwd="$BOT_PASSWORD_MD5" --no-check-certificate --output-document=- "$TOKEN_URL"`
if [ -n "$CSRF_TOKEN" ]; then
	CSRF_HEADER="--header $CSRF_TOKEN"
fi

echo "Notifying Jenkins ..."
/usr/bin/wget \
  --timeout=2 \
  --tries=3 \
  --header="Content-Type:text/plain;charset=UTF-8" \
  --post-data="$CHANGES" \
  --output-document=- \
  --auth-no-challenge \
  --http-user="$BOT_USER" \
  --http-passwd="$BOT_PASSWORD_MD5" \
  --no-check-certificate \
  $CSRF_HEADER \
  "$NOTIFY_URL"

