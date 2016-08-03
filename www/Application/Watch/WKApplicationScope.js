/**
 * This handler will be invoked when a MessagePort connection is opened between the associated SharedWorker and the main thread.
 * @parameter   {MessageEvent} event 
 */
onconnect = function (event) {
    console.info("[WKApplicationScope.onconnect]", event);
    var port = event.ports[0];
    if (!port) { return; }
    port.addEventListener("message", function (event) {
        console.info("[WKApplicationScope.onconnect.port] message from outside", event.data);
    });
    port.start();
};

/**
 * This handler will be invoked when a WCMessagePort connection is opened between the associated WCSharedWorker and the main thread.
 * @parameter   {MessageEvent} event
 */
onwatchconnect = function (event) {
    console.info("[WKApplicationScope.onwatchconnected]", event);
    // TODO: handle event here
    var port = event.ports[0];
    if (!port) { return; }
    port.addEventListener("message", function (event) {
        console.info("[WKApplicationScope.onwatchconnect.port] message from outside", event.data);
    });
    port.start();
};

/**
 * This handler will be invoked when a WCMessagePort connection is closed between the associated WCSharedWorker and the main thread.
 * @parameter   {MessageEvent} event
 */
onwatchdisconnect = function (event) {
    // TODO: handle event here
    console.debug("On smartwatch disconnected", event);
};

/**
 * This handler will be invoked when an error occurs.
 * @parameter   {MessageEvent} event
 */
onerror = function (event) {
    console.error("Error in WKApplicationScope", event);
}