onconnect = function (event) {
    console.log("On SharedWorkerGlobalScope connected", event);
    var port = event.ports[0];
    if (!port) { return; }
    port.start();
    port.addEventListener("message", this.onmessage.bind(this));
};

onwatchconnect = function(event) {
    console.log("On Apple Watch connected", event);
    var port = event.ports[0];
    if (!port) { return; }
    port.start()
    port.addEventListener("message", this.onmessage.bind(this));
};

onmessage = function (event) {
    console.log("Message received from outside", event.data);
};