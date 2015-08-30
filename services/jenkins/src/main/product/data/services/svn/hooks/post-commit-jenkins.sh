#!/bin/sh
# Jenkins commit notification hook

. "@{product.bin}/loadenv.sh"

REPOS="$1"
REV="$2"
UUID=`svnlook uuid $REPOS`
CHANGES=`svnlook changed --revision $REV $REPOS`
URL="@{product.scheme}://$PRODUCT_DOMAIN/jenkins/subversion/$UUID/notifyCommit?rev=$REV"

echo "Notifying Jenkins ..."
/usr/bin/wget \
  --timeout=2 \
  --tries=3 \
  --header="Content-Type:text/plain;charset=UTF-8" \
  --post-data="$CHANGES" \
  --output-document="-" \
  --auth-no-challenge \
  --http-user=$BOT_USER \
  --http-passwd=$BOT_PASSWORD_MD5 \
  --no-check-certificate \
  $URL

