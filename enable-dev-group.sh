source resin.env

device_list=$(curl -X GET -H "Authorization: Bearer  $authToken" -H "Content-Type: application/json" "https://api.$BASE_URL/v2/device?\$expand=device_environment_variable%2Capplication&\$filter=application/app_name%20eq%20%27$APP_NAME%27%20and%20device_environment_variable/env_var_name%20eq%20%27DEV%27&\$select=id" | jq '.d[] | .id')

array=($device_list)
for i in "${array[@]}"
do
	echo "setting device $i to track rolling release"
    # ./set-device-to-a-build.sh $i null
    curl -X PATCH "https://api.$BASE_URL/v2/device($i)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json" --data-binary '{"build":null}'
done

64488

curl "https://api.$BASE_URL/v2/device(64488)" -H "Authorization: Bearer $authToken" -H "Content-Type: application/json"