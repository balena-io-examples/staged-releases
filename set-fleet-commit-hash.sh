source resin.env
COMMIT_HASH=$1
echo "setting APP: $APP_ID to COMMIT == $COMMIT_HASH"
curl -X PATCH "https://api.$BASE_URL/v2/application($APP_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"commit":"'$COMMIT_HASH'"}'
