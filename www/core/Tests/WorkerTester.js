onconnect = function (event) {
    console.debug("On global scope connected!", event);
    var port = event.ports[0];
    // port.onmessage = function (event) {
    //     console.debug("Message from outside context", event.data);
    //     console.info("About to post message to the outside port!");
    //     port.start();
    //     port.postMessage(`Inside port has received message: ${event.data}`);
    // };
    // Handler added by Events APIs
    port.addEventListener("message", function(event) {
        console.debug("Message from outside context", event.data);
        console.info("About to post message to the outside port!");
        port.postMessage(`Inside port has received message: ${event.data}`);
    });
    port.start();
    port.postMessage("Inside global scope has been successfully connected!");
};