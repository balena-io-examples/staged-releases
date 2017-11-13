## This script sets a single device to a specific build of a commit.
## To set a device back to the most recent release, run this script without a commit hash parameter.
## Usage: ./set-device-to-a-build.sh <DEVICE_UUID> <FULL_COMMIT_HASH>
## Usage: ./set-device-to-a-build.sh <DEVICE_UUID>

source ./resin.env
DEVICE_UUID=$1
DEVICE_ID=$(./get-device-id.sh $DEVICE_UUID)

# For backwards compatibility, in case that a device for the provided parameter was not found
# and the the provided parameter is an integer, then we use it as the DEVICE_ID
IntRegex='^[1-9][0-9]{0,9}$'
if ! [[ $DEVICE_ID =~ $IntRegex ]] && [[ $DEVICE_UUID =~ $IntRegex ]] ; then
	echo "using DEVICE parameter as ID"
	DEVICE_ID=$DEVICE_UUID
fi

COMMIT=$2
BUILD_ID=$(./get-build-id.sh $COMMIT)
echo "setting device $DEVICE_ID to commit $COMMIT with buildID = $BUILD_ID"
curl -X PATCH "https://api.$BASE_URL/v2/device($DEVICE_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"build":'$BUILD_ID'}'
