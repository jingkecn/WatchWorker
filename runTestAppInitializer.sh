##!/bin/sh

# PATH="./SmartwatchWorkerExample"
# ID="com.wiztivi.examples.smartwatchworker"
# NAME="SmartwatchWorkerExample"

mkdir -p testapps
cd testapps
cordova create SmartwatchWorkerExample com.wiztivi.examples.smartwatchworker SmartwatchWorkerExample
cd SmartwatchWorkerExample
cordova plugin add ../../ --save
cordova plugin add http://git-wip-us.apache.org/repos/asf/cordova-plugin-test-framework.git --save
cordova platform add ios