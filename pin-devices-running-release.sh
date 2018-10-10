#!/usr/bin/env bash
## This script sets devices running a commit to be pinned to that specific commit
## Usage: ./pin-devices-to-current-release <FULL_COMMIT_HASH>

./check-configuration.sh || exit 1

source ./resin.env

COMMIT=$1
if [ -z $COMMIT ]; then
	echo "Please specify a commit"
	exit 1
else
	RELEASE_ID=$(./get-release-id.sh $COMMIT)
fi
echo "setting devices with commit $COMMIT with release = $RELEASE_ID"
curl -X PATCH "https://api.$BASE_URL/v4/device?\$filter=is_on__commit%20eq%20'$COMMIT'" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"should_be_running__release":'$RELEASE_ID'}'
