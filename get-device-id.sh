#!/usr/bin/env bash
## This script returns the `device_id` for a specific device on a balena application.
## usage: ./get-device-id.sh <DEVICE_UUID>

./check-configuration.sh || exit 1

DEVICE_UUID=$1
if [ -f "./resin.env" ]; then
    source ./resin.env
fi
source ./balena.env

curl "https://api.$BASE_URL/v5/device?\$select=id,uuid&\$filter=uuid%20eq%20'$DEVICE_UUID'" -H "Authorization: Bearer $authToken" | jq '.d[0].id'
