# Staged Updates on balena

This repo is a collection of scripts to demonstrate some of the new API endpoints offered on balenaCloud to enable the more fine grained control of app updates across a fleet of devices.
These scripts simply show how to use the available primitives and in the near future this functionality will be surfaced on the UI and via the CLI.

To use these scripts you need to edit the `balena.env` file adding the Application you want to operate on (replacing APP_ID with the appropriate value) and your `authToken` from the preferences page on the balenaCloud dashboard.
* Note that while using `resin.env` is still supported, it is destined for deprecation and is discouraged.

At a basic level, these scripts allow one to disable the auto tracking on the App, so that the fleet no longer automatically updates every time you do a `git push balena master`. They also allow one to set a group of devices (marked with a device tag) to advance to a specific commit/build (selected from the releases list).
Using the primitives shown in these scripts one could have a fleet of devices and deploy specific commits to specific subgroups as and when needed. It would be very easy to set up a system where developers have devices in the fleet set to `local mode` so they can test and develop locally, and when happy commit and merge the code into a branch that would then be released to the larger testing group. Obviously once the code being tested on the testing group is deemed stable, it would then be released to the whole fleet by advancing the fleet wide `Application commit`.

## Prerequisites

1. a balenaCloud account
2. your system should have `jq` and `curl` installed
## Usage:

1. Ensure that `balena.env` is updated with the correct `APP_ID` and `authToken`
2. To disable the automatic update tracking run:
```
./disable-rolling-release-on-fleet.sh
```
3. We can now set the whole fleet to a specific commit (something we decide is "stable" or "production") by running:
```
./set-fleet-commit-hash.sh <PUT YOUR FULL COMMIT HASH HERE>
```
Note that you need to provide the full commit hash for this command. It should also be noted that any devices that join/provision into the fleet after this is set, will download and update this commit. To confirm that this has worked, check the top right of the device list page and you should see the `Application commit:` value has been set to the commit you passed it in the command.

4. If we want to have a few devices that are part of a testing group, we can use the `set-device-to-a-release.sh` script:
```
./set-device-to-a-release.sh <DEVICE FULL UUID HERE> <FULL COMMIT HASH HERE>
```

5. For convenience, we can define a device tag with `TEST` (or any other tag) as its key that is used to designate the devices that are part of the testing group. So any device in the fleet that has the `TEST` tag can then be set with a testing build. The `update-test-group.sh` script will set all the devices with this tag to a specific commit/build:
```
./update-test-group.sh <FULL COMMIT HASH HERE> <TAG NAME>
```

Where `<TAG NAME>` defaults to `TEST` if not provided.

Note: this must be the full commit hash. It may take a few seconds for the test devices to start updating to the correct version of the code.

## Returning to rolling releases

If you want to return the fleet to keep tracking rolling releases and downloading updates whenever they are pushed, just run:
```
./enable-rolling-release-on-fleet.sh
```
and push a new commit, or use `set-fleet-commit-hash.sh` to set the App commit to the latest.

In case that you want to restore tracking releases on devices that were configured using `set-device-to-a-release.sh` or `update-test-group.sh`, you will need run the respective commands with an empty commit hash (this will set the target commit to `null`). So for a specific device you will need to run:
```
./set-device-to-a-release.sh <DEVICE FULL UUID HERE>
```

For a test group of devices you will need to run:
```
./update-test-group.sh
```
