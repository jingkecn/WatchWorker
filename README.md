Smart Watch Worker Plugin for Cordova
---
This is an experimental plugin for communication between a smart watch and its encountered mobile using HTML5 SharedWorker API

# Messaging

## Initialization

You must initialize smartwatchworker to evaluate your script file in the new JavaScript context.

``` javascript
/**
 * Initialize a worker instance for smart watch
 * @parameter   {string}    url (currently is the filename of your script, without a suffix)
 * @parameter   {callback}  onSuccess
 * @parameter   {callback}  onError
 */
smartwatchworker.initialize(url, onSuccess, onError);
```

## Message Sender

``` javascript
// Please ensure that smartwatchworker has been successfully initialized
 smartwatchworker.initialize(url, function() {
     /**
      * Post a message to smart watch
      * @parameter   {string}    message
      * @parameter   {callback}  onSuccess
      * @parameter   {callback}  onError
      */
      smartwatchworker.postMessage(message, onSuccess, onError);
 }, onError);
```

## Message Listener

``` javascript
// Please ensure that smartwatchworker has been successfully initialized
 smartwatchworker.initialize(url, function() {
     /**
      * Add event listener to smartwatchworker
      * @parameter   {string}    type
      * @parameter   {callback}  callback
      */
      smartwatchworker.addEventListener(type, callback);
      // An example
      smartwatchworker.addEventListener("message", function(message) {
          // TODO: message handler
      });

    /**
     * Remove event listener from smartwatchworker
     * @parameter   {string}    type
     * @parameter   {callback}  onSuccess
     * @parameter   {callback}  onError
     */
     smartwatchworker.removeEventListener(type, onSuccess, onError);
 }, onError);
```

## Example

``` javascript
// On worker successfully initialized
var onSuccess = function () {
    smartwatchworker.addEventListener("message", function (message) {
        // Receiving message
    });
    smartwatchworker.addEventListener("error", function (error) {
        // Receiving error
    });
    smartwatchworker.postMessage("Message from web view!");
};
// On worker initialized error
var onError = function () {};
// Initialization
smartwatchworker.initialize("InsideWatchWorker", onSuccess, onError);
```