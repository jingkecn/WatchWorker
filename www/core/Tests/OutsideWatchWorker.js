importScripts("InsideWatchWorker");

var worker = new WCSharedWorker("InsideWatchWorker");
var port = worker.port;
port.start();
port.addEventListener("message", function (event) {
    console.info("Receiving message from Apple Watch", event.data);
});
port.postMessage("Sending message to Apple Watch");