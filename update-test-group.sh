# This script sets a group of devices to a specific commit,
# currently it will look for devices in an app that have an environment variable called "TEST"
# these devices will then update to whatever commit is supplied as arg $1

COMMIT_HASH=$1
source resin.env

device_list=$(curl -X GET -H "Authorization: Bearer  $authToken" -H "Content-Type: application/json" "https://api.$BASE_URL/v2/device?\$expand=device_environment_variable%2Capplication&\$filter=application/app_name%20eq%20%27$APP_NAME%27%20and%20device_environment_variable/env_var_name%20eq%20%27TEST%27&\$select=id" | jq '.d[] | .id')

array=($device_list)
for i in "${array[@]}"
do
	echo "setting update commit for device == $i"
    ./set-device-to-a-build.sh $i $1
done