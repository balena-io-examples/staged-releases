######################## Disable Rolling Release for an App ################################################
# This script stops the automatic updating of devices in an App whenever a new build is triggered.
# You will also need to set a specific Application commit to lock the App to, use the "set-fleet-commit-hash.sh"
# script to lock to a specific commit from your list of builds in your "Build logs" page on the dashboard.
############################################################################################################
# Bring our resin Token, URL, etc from resin.env file
source resin.env

echo "Disabling rolling release tracking for APP == $APP_ID"
curl -X PATCH "https://api.$BASE_URL/v2/application($APP_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"should_track_latest_release":false}'

# Check that it was applied.
curl "https://api.$BASE_URL/v2/application($APP_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" | jq .

