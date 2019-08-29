#!/usr/bin/env bash
## This script sets devices targeting a given commit to target a new commit
## Usage: ./pin-devices-to-target-release <FULL_COMMIT_HASH> <NEW_FULL_COMMIT_HASH>
## This is useful when you have a set of devices which are running release A,
## have been targeted to release B, but you want them to now target release C.

./check-configuration.sh || exit 1

if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env

COMMIT=$1
NEW_COMMIT=$2
if [ -z $COMMIT ]; then
    echo "Please specify a commit to upgrade from"
    exit 1
elif [ -z $NEW_COMMIT ]; then
    echo "Please specify a commit to upgrade to"
    exit 1
else
    RELEASE_ID=$(./get-release-id.sh $COMMIT)
    NEW_RELEASE_ID=$(./get-release-id.sh $NEW_COMMIT)
fi
echo "setting devices with commit $COMMIT with release = $RELEASE_ID to $NEW_COMMIT with release = $NEW_RELEASE_ID"
curl -X PATCH "https://api.$BASE_URL/v5/device?\$filter=should_be_running__release%20eq%20'$RELEASE_ID'" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"should_be_running__release":'$NEW_RELEASE_ID'}'
