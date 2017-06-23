#!/bin/sh
#
# This script sets the fleet wide commit hash to a specified value.
# It is usually used after one has disabled rolling releases and allows one
# to set an entire fleet to any specific build in their list of builds for an App.

. resin.env
COMMIT_HASH=$1

echo "setting APP: $APP_ID to COMMIT == $COMMIT_HASH"
curl -X PATCH "https://api.$BASE_URL/v2/application($APP_ID)" \
    -H "Authorization: Bearer $authToken" \
    -H "Content-Type: application/json" \
    --data-binary '{"commit":"'$COMMIT_HASH'"}'
