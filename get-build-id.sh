## This script returns the `build_id` for a specific commit on a resin.io application.
## usage: ./get-build-id.sh <FULL_COMMIT_HASH>
if [ "$#" -ne 1 ]
then
  echo "Usage:"
  echo "  $0 FULL_COMMIT_HASH"
  exit 0
fi

COMMIT_HASH=$1
source ./resin.env

curl "https://api.$BASE_URL/v2/build?\$select=id,commit_hash&\$filter=application%20eq%20$APP_ID%20and%20commit_hash%20eq%20'$COMMIT_HASH'" -H "Authorization: Bearer $authToken" | jq '.d[0].id' 
