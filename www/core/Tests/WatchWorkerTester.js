onmessage = function(event) {
    console.log("Message from outside port", event);
};

onwatchconnected = function(event) {
    console.log("On Apple Watch connected", event);
    var port = event.port[0];
    if (!port) { return; }
    port.addEventListener("message", this.onmessage);
};
