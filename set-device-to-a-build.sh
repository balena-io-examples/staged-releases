## This script sets a single device to a specific build of a commit.
## Usage: ./set-device-to-a-build.sh <DEVICE_ID> <FULL_COMMIT_HASH>
source ./resin.env
DEVICE_ID=$1
COMMIT=$2
BUILD_ID=$(./get-build-id.sh $COMMIT)
echo "setting device $DEVICE_ID to commit $COMMIT with buildID = $BUILD_ID"
curl -X PATCH "https://api.$BASE_URL/v2/device($DEVICE_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"build":'$BUILD_ID'}'
