importScripts("WKApplication.js");

WKApplication.singleton.initialize();

onconnect = function (event) {
    console.info("[ApplicationScope.onconnect]", event);
    var port = event.ports[0];
    if (!port) { return; }
    port.addEventListener("message", function (event) {
        console.log("[ApplicationScope.onconnect.port] message from outside", event.data);
    });
    port.start();
};