cordova.define("com.wiztivi.cordova.plugins.smartwatchworker.SmartWatchWorker", function(require, exports, module) {
var exec = require('cordova/exec');

exports.initialize = function (url, onSuccess, onError) {
    exec(onSuccess, onError, "SmartWatchWorker", "initialize", [{"url": url}]);
};

exports.postMessage = function (message, onSuccess, onError) {
    message = (typeof message === "object") ? JSON.stringify(message) : message;
    exec(onSuccess, onError, "SmartWatchWorker", "postMessage", [{"message": message}]);
};

exports.addEventListener = function (type, callback) {
    if (typeof type !== "string") { return; }
    if (type === "error") {
        exec(null, callback, "SmartWatchWorker", "addEventListener", [{"type": type}]);
        return;
    }
    exec(callback, null, "SmartWatchWorker", "addEventListener", [{"type": type}]);
};

exports.removeEventListener = function (type, onSuccess, onError) {
    if (typeof type !== "string") { return; }
    exec(onSuccess, onError, "SmartWatchWorker", "removeEventListener", [{"type": type}]);
};

});
