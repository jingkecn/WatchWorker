var exec = require('cordova/exec');

/**
 * Initialize a worker instance for smart watch
 * @parameter   {string}    url (currently is the filename of your script, without a suffix)
 * @parameter   {callback}  onSuccess
 * @parameter   {callback}  onError
 */
exports.initialize = function (url, onSuccess, onError) {
    exec(onSuccess, onError, "SmartWatchWorker", "initialize", [{"url": url}]);
};

/**
 * Post a message to smart watch
 * @parameter   {string}    message
 * @parameter   {callback}  onSuccess
 * @parameter   {callback}  onError
 */
exports.postMessage = function (message, onSuccess, onError) {
    message = (typeof message === "object") ? JSON.stringify(message) : message;
    exec(onSuccess, onError, "SmartWatchWorker", "postMessage", [{"message": message}]);
};

/**
 * Add event listener to smartwatchworker
 * @parameter   {string}    type
 * @parameter   {callback}  callback
 */
exports.addEventListener = function (type, callback) {
    if (typeof type !== "string") { return; }
    if (type === "error") {
        exec(null, callback, "SmartWatchWorker", "addEventListener", [{"type": type}]);
        return;
    }
    exec(callback, null, "SmartWatchWorker", "addEventListener", [{"type": type}]);
};

/**
 * Remove event listener from smartwatchworker
 * @parameter   {string}    type
 * @parameter   {callback}  onSuccess
 * @parameter   {callback}  onError
 */
exports.removeEventListener = function (type, onSuccess, onError) {
    if (typeof type !== "string") { return; }
    exec(onSuccess, onError, "SmartWatchWorker", "removeEventListener", [{"type": type}]);
};
