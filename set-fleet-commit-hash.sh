#!/usr/bin/env bash
## This script sets the fleet wide commit hash to a specified value.
## It is usually used after one has disabled rolling releases and allows one
## to set an entire fleet to any specific build in their list of builds for an App.

./check-configuration.sh || exit 1

if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env
COMMIT_HASH=$1
RELEASE_ID=$(./get-release-id.sh $COMMIT_HASH)
echo "setting APP: $APP_ID to release = $RELEASE_ID with commit $COMMIT_HASH"
curl -X PATCH "https://api.$BASE_URL/v6/application($APP_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"should_be_running__release":'$RELEASE_ID'}'
