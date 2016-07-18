##!/bin/sh

# PATH="./SmartWatchWorkerExample"
# ID="com.wiztivi.examples.smartwatchworker"
# NAME="SmartWatchWorkerExample"

cordova create SmartWatchWorkerExample com.wiztivi.examples.smartwatchworker SmartWatchWorkerExample
cd SmartWatchWorkerExample
cordova plugin add ../../ --save
cordova plugin add http://git-wip-us.apache.org/repos/asf/cordova-plugin-test-framework.git --save