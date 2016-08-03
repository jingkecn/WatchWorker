WatchWorker Plugin for Cordova
---
This is an experimental plugin for asynchronous communication between a smartwatch and its encountered mobile using HTML5 SharedWorker APIs.

# Prequisites

## For iOS
This plugin is ***ONLY*** available for **iOS9.3**, so please make sure that the deployment target is set to version **9.3** in your Xcode project (both project settings and target settings).

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
    [[WatchWorker sharedInstance] initializeWatchWorkerWithUrl:@"ApplicationScope"];
    [[WCMessageService sharedInstance] startServiceOnSuccess:nil onError:nil];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

# Messaging

## Initialization

You must initialize watchworker to evaluate your script file in the new JavaScript context.

``` javascript
/**
 * Initialize a worker instance for smartwatch
 * @parameter   {string}    url (currently is the filename of your script, without a suffix)
 * @parameter   {callback}  onSuccess
 * @parameter   {callback}  onError
 */
watchworker.initialize(url, onSuccess, onError);
```

## Message Sender

``` javascript
// Please ensure that watchworker has been successfully initialized
 watchworker.initialize(url, function() {
     /**
      * Post a message to smartwatch
      * @parameter   {string}    message
      * @parameter   {callback}  onSuccess
      * @parameter   {callback}  onError
      */
      watchworker.postMessage(message, onSuccess, onError);
 }, onError);
```

## Message Listener

``` javascript
// Please ensure that watchworker has been successfully initialized
 watchworker.initialize(url, function() {
     /**
      * Add event listener to watchworker
      * @parameter   {string}    type
      * @parameter   {callback}  callback
      */
      watchworker.addEventListener(type, callback);
      // An example
      watchworker.addEventListener("message", function(message) {
          // TODO: message handler
      });

    /**
     * Remove event listeners from watchworker
     * @parameter   {string}    type
     * @parameter   {callback}  onSuccess
     * @parameter   {callback}  onError
     */
     watchworker.removeEventListener(type, onSuccess, onError);
 }, onError);
```

## Example

``` javascript
// On worker successfully initialized
var onSuccess = function () {
    watchworker.addEventListener("message", function (message) {
        // Receiving message
    });
    watchworker.addEventListener("error", function (error) {
        // Receiving error
    });
    watchworker.postMessage("Message from web view!");
};
// On worker initialized error
var onError = function () {};
// Initialization with a context in script file named InsideWatchWorker.js
watchworker.initialize("ApplicationScope", onSuccess, onError);
```