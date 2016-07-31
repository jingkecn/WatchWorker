/**
 * This handler will be invoked when a MessagePort connection is opened between the associated SharedWorker and the main thread.
 * @parameter   {MessageEvent} event 
 */
onmessage = function(event) {
    console.info("Message received from outside port", event.data);
}

onconnect = function (event) {
    var port = event.ports[0];
    if (!port) { return; }
    port.addEventListener("message", this.onmessage.bind(this));
    port.start();
};

/**
 * This handler will be invoked when a WCMessagePort connection is opened between the associated WCSharedWorker and the main thread.
 * @parameter   {MessageEvent} event
 */
onwatchconnected = function (event) {
    // TODO: handle event here
    console.debug("On smartwatch connected", event);
    var port = event.ports[0];
    if (!port) { return; }
    port.start();
    port.addEventListener("message", this.onmessage.bind(this));
};

/**
 * This handler will be invoked when a WCMessagePort connection is closed between the associated WCSharedWorker and the main thread.
 * @parameter   {MessageEvent} event
 */
onwatchdisconnected = function (event) {
    // TODO: handle event here
    console.debug("On smartwatch disconnected", event);
};

/**
 * This handler will be invoked when an error occurs.
 * @parameter   {MessageEvent} event
 */
onerror = function (event) {
    console.error("Error in WKAppScope", event);
}