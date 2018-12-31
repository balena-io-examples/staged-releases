#!/usr/bin/env bash
## This script sets a single device to a specific build of a commit.
## To set a device back to the most recent release, run this script without a commit hash parameter.
## Usage: ./set-device-to-a-release.sh <DEVICE_UUID> <FULL_COMMIT_HASH>
## Usage: ./set-device-to-a-release.sh <DEVICE_UUID>

./check-configuration.sh || exit 1

if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env
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
if [ -z $COMMIT ]; then
	RELEASE_ID="null"
else
	RELEASE_ID=$(./get-release-id.sh $COMMIT)
fi
echo "setting device $DEVICE_ID to commit $COMMIT with release = $RELEASE_ID"
curl -X PATCH "https://api.$BASE_URL/v4/device($DEVICE_ID)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"should_be_running__release":'$RELEASE_ID'}'
