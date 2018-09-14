#!/usr/bin/env bash
# This script sets a group of devices to a specific commit,
# currently it will look for devices in an app that have a tag specified as arg $1
# these devices will then update to whatever commit is supplied as arg $2

./check-configuration.sh || exit 1

TARGET_TAG_KEY=$1
COMMIT_HASH=$2
source ./resin.env

if [ -z $COMMIT_HASH ]; then
	RELEASE_ID="null"
else
	RELEASE_ID=$(./get-release-id.sh $COMMIT_HASH)
fi

echo "Setting all devices with tag $TARGET_TAG_KEY to commit $COMMIT_HASH with release = $RELEASE_ID"
curl -X PATCH -H "authorization: Bearer $authToken"\
  -H "Content-Type: application/json" \
	--data-binary '{"should_be_running__release":'$RELEASE_ID'}' \
	"https://api.$BASE_URL/v4/device?\$expand=belongs_to__application(\$select=id),device_tag(\$select=id,tag_key)&\$filter=((belongs_to__application%20eq%20$APP_ID)%20and%20(device_tag/any(dt:((tag_key)%20eq%20(%27$TARGET_TAG_KEY%27)))))"
