onconnect = function (event) {
    console.log("On SharedWorkerGlobalScope connected", event);
    var port = event.ports[0];
    port.addEventListener("message", function (event) {
        port.postMessage(event.data);
    });
    port.start();
};