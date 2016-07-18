// Create a smartwatch worker
var worker = new WCSharedWorker("InsideWatchWorker");
var port = worker.port;
// Start the message port
port.start();
// Add message event listener
port.addEventListener("message", function (event) {
    console.info("Receiving message from Apple Watch", event.data);
});
// Post message to the smartwatch
port.postMessage("Sending message to Apple Watch");