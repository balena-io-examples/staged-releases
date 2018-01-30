# This script sets a group of devices to a specific commit,
# currently it will look for devices in an app that have an environment variable called "TEST"
# these devices will then update to whatever commit is supplied as arg $1

COMMIT_HASH=$1
source ./resin.env

TARGET_TAG_KEY='TEST'

device_list=$(curl -X GET -H "authorization: Bearer $authToken" -H "Content-Type: application/json" "https://api.$BASE_URL/v3/device?\$expand=belongs_to__application(\$select=id),device_tag(\$select=id,tag_key)&\$filter=((belongs_to__application%20eq%20$APP_ID)%20and%20(device_tag/any(dt:((tag_key)%20eq%20(%27$TARGET_TAG_KEY%27)))))&\$select=id" | jq '.d[] | .id')

array=($device_list)
for i in "${array[@]}"
do
	echo "setting update commit for device == $i"
	./set-device-to-a-build.sh $i $1
done