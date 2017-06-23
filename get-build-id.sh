#!/bin/sh
#
# This script returns the `build_id` for a specific commit on a resin.io application.
# usage: ./get-build-id.sh <FULL_COMMIT_HASH>

COMMIT_HASH=$1
. resin.env

curl "https://api.$BASE_URL/v2/build?\$select=id,commit_hash&\$filter=application%20eq%20$APP_ID%20and%20commit_hash%20eq%20'$COMMIT_HASH'" \
    -H "Authorization: Bearer $authToken" \
    | jq '.d[0].id'
