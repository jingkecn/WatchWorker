##!/bin/sh

# PATH="./SmartWatchWorkerExample"
# ID="com.wiztivi.examples.smartwatchworker"
# NAME="SmartWatchWorkerExample"

mkdir -p testapps
cd testapps
cordova create SmartWatchWorkerExample com.wiztivi.examples.smartwatchworker SmartWatchWorkerExample
cd SmartWatchWorkerExample
cordova plugin add ../../ --save
cordova plugin add http://git-wip-us.apache.org/repos/asf/cordova-plugin-test-framework.git --save