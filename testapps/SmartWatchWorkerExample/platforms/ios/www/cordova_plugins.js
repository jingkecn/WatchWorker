cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/com-wiztivi-cordova-plugin-smartwatchworker/www/SmartWatchWorker.js",
        "id": "com-wiztivi-cordova-plugin-smartwatchworker.SmartWatchWorker",
        "pluginId": "com-wiztivi-cordova-plugin-smartwatchworker",
        "clobbers": [
            "smartwatchworker"
        ]
    },
    {
        "file": "plugins/cordova-plugin-test-framework/www/tests.js",
        "id": "cordova-plugin-test-framework.cdvtests",
        "pluginId": "cordova-plugin-test-framework"
    },
    {
        "file": "plugins/cordova-plugin-test-framework/www/jasmine_helpers.js",
        "id": "cordova-plugin-test-framework.jasmine_helpers",
        "pluginId": "cordova-plugin-test-framework"
    },
    {
        "file": "plugins/cordova-plugin-test-framework/www/medic.js",
        "id": "cordova-plugin-test-framework.medic",
        "pluginId": "cordova-plugin-test-framework"
    },
    {
        "file": "plugins/cordova-plugin-test-framework/www/main.js",
        "id": "cordova-plugin-test-framework.main",
        "pluginId": "cordova-plugin-test-framework"
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-add-swift-support": "1.3.1",
    "com-wiztivi-cordova-plugin-smartwatchworker": "0.0.1",
    "cordova-plugin-test-framework": "1.1.3-dev",
    "cordova-plugin-whitelist": "1.2.2"
}
// BOTTOM OF METADATA
});