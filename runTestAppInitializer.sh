##!/bin/sh

# PATH="./WatchWorkerExample"
# ID="com.wiztivi.examples.watchworker"
# NAME="WatchWorkerExample"

rm -rf testapps
mkdir -p testapps
cd testapps
cordova create WatchWorkerExample com.wiztivi.examples.watchworker WatchWorkerExample
cd WatchWorkerExample
cordova platform add ios
cordova plugin add ../../ --save
cordova plugin add http://git-wip-us.apache.org/repos/asf/cordova-plugin-test-framework.git --save