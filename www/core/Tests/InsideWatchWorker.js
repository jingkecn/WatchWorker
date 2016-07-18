/**
 * This handler will be invoked when a MessagePort connection is opened between the associated SharedWorker and the main thread.
 * @parameter   {MessageEvent} event 
 */
onconnect = function (event) {
    console.debug("On global scope connected!", event);
    var port = event.ports[0];
    port.addEventListener("message", function(event) {
        console.debug("Message from outside port", event.data);
    });
    port.start();
    // post message to the outside port
    // port.postMessage("Inside global scope has been successfully connected!");
};

/**
 * This handler will be invoked when a WCMessagePort connection is opened between the associated WCSharedWorker and the main thread.
 * @parameter   {MessageEvent} event
 */
onwatchconnected = function (event) {
    // TODO: handle event here
    var port = event.ports[0];
    port.addEventListener("message", function(event) {
        console.debug("Message from outside port", event.data);
        // port.postMessage(`Inside port has received message: ${event.data}`);
    });
    port.start();
    // port.postMessage("Smart watch has been successfully connected!");
};

/**
 * This handler will be invoked when a WCMessagePort connection is closed between the associated WCSharedWorker and the main thread.
 * @parameter   {MessageEvent} event
 */
onwatchdisconnected = function (event) {
    // TODO: handle event here
    var port = event.ports[0];
    port.addEventListener("message", function(event) {
        console.debug("Message from outside port", event.data);
        // port.postMessage(`Inside port has received message: ${event.data}`);
    });
    port.start();
    // port.postMessage("Smart watch has been disconnected!");
};

/**
 * This handler will be invoked when an error occurs.
 * @parameter   {MessageEvent} event
 */
onerror = function (event) {
    console.error("Error in WCWorkerTester", event);
}