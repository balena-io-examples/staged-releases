#!/usr/bin/env bash
# This script sets a group of devices to a specific commit,
# currently it will look for devices in an app that have a tag specified as arg $2, optionally with a specific value specified as arg $3
# these devices will then update to whatever commit is supplied as arg $1
# If a tag is not provided, it will use the TEST tag with any value as default.

./check-configuration.sh || exit 1

COMMIT_HASH=$1
TARGET_TAG_KEY=$2
TARGET_TAG_VALUE=$3

if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env

if [ -z $COMMIT_HASH ]; then
	RELEASE_ID="null"
else
	RELEASE_ID=$(./get-release-id.sh $COMMIT_HASH)
fi

if [ -z "$TARGET_TAG_KEY" ]; then
	TARGET_TAG_KEY="TEST"
fi

if [ ! -z "$TARGET_TAG_VALUE" ] ; then
  VALUE_QUERY="and%20(device_tag/any(dt:((tag_value)%20eq%20(%27$TARGET_TAG_VALUE%27))))"
  VALUE_MSG="and value $TARGET_TAG_VALUE"
else
  VALUE_MSG="with any value"
fi

echo "Setting all devices with tag $TARGET_TAG_KEY $VALUE_MSG to commit $COMMIT_HASH with release = $RELEASE_ID"

curl -X PATCH -H "authorization: Bearer $authToken"\
  -H "Content-Type: application/json" \
	--data-binary '{"should_be_running__release":'$RELEASE_ID'}' \
	"https://api.$BASE_URL/v5/device?\$expand=belongs_to__application(\$select=id),device_tag(\$select=id,tag_key)&\$filter=((belongs_to__application%20eq%20$APP_ID)%20and%20(device_tag/any(dt:((tag_key)%20eq%20(%27$TARGET_TAG_KEY%27))))$VALUE_QUERY)"
