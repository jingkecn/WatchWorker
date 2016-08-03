onmessage = function(event) {
    console.log("Message from outside port", event);
    postMessage(event.data);
};