#!/usr/bin/env bash
# This file checks that the settings in balena.env are loaded and authenticating correctly

if [ -f "./resin.env" ]; then
    echo "WARNING: resin.env usage is deprecated, please start using balena.env"
    source ./resin.env
fi
source ./balena.env
response=$(curl --silent "https://api.$BASE_URL/user/v1/whoami" -H "Authorization: Bearer $authToken")

if [ $? -ne 0 ]; then
    echo "Could not authenticate to '$BASE_URL', please check your configuration"
    exit 1
fi
