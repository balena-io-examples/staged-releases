#!/usr/bin/env bash
## This script returns the `build_id` for a specific commit on a balena application.
## usage: ./get-build-id.sh <FULL_COMMIT_HASH>

./check-configuration.sh || exit 1

COMMIT_HASH=$1
if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env

curl "https://api.$BASE_URL/v6/release?\$select=id,commit&\$filter=belongs_to__application%20eq%20$APP_ID%20and%20commit%20eq%20'$COMMIT_HASH'%20and%20status%20eq%20'success'" -H "Authorization: Bearer $authToken" | jq '.d[0].id'
