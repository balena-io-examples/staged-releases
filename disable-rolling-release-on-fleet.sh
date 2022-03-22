#!/usr/bin/env bash
######################## Disable Rolling Release for an App ################################################
# This script stops the automatic updating of devices in an App whenever a new build is triggered.
# You will also need to set a specific Application commit to lock the App to, use the "set-fleet-commit-hash.sh"
# script to lock to a specific commit from your list of builds in your "Build logs" page on the dashboard.
############################################################################################################

./check-configuration.sh || exit 1

# Bring our balena Token, URL, etc from balena.env file
if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env

# Patch call to set "should_track_latest_release"  to false
echo "Disabling rolling release tracking for APP == $APP_ID"
curl -X PATCH "https://api.$BASE_URL/v6/application($APP_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"should_track_latest_release":false}'

# Check that it was applied.
curl "https://api.$BASE_URL/v6/application($APP_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" | jq .
