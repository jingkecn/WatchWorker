Smartwatch Worker Plugin for Cordova
---
This is an experimental plugin for asynchronous communication between a smartwatch and its encountered mobile using HTML5 SharedWorker APIs.

# Prequisites

## For iOS
This plugin is ***ONLY*** available for **iOS9.x**, so please make sure that the deployment target is set to version **9.x** in your Xcode project (both project settings and target settings).

Please replace the contents in `AppDelegate.m` file within your Xcode project by the following lines.

``` objc 
#import "AppDelegate.h"
#import "MainViewController.h"
// replace the placeholder {ProjectName} by your Xcode project name to import Swift classes.
#import "{ProjectName}-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.viewController = [[MainViewController alloc] init];
    // start WCMessageService to support background communication between iOS and Watch OS
    [[WCMessageService defaultService] startServiceOnSuccess:nil onError:nil];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

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
     * Remove event listeners from smartwatchworker
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
// Initialization with a context in script file named InsideWatchWorker.js
smartwatchworker.initialize("InsideWatchWorker", onSuccess, onError);
```