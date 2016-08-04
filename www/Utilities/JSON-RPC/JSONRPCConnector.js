importScripts("JSONRPCError");
importScripts("JSONRPCMessage");

class JSONRPCConnector {

    constructor(port) {
        this.listeners = {}
        this.port = port;
        this.port.addEventListener("message", function (event) {
            try {
                console.info("JSONRPCConnector receive a message", event.data);
                this.dispatchMessage(new JSONRPCMessage(JSON.parse(event.data)));
            } catch (error) {
                console.error(error);
                this.sendErrorMessage(JSONRPCError.PARSE_ERROR);
            }
        }.bind(this));
        this.addMessageListener("error", this.onErrorMessage.bind(this));
    }

    sendErrorMessage(error) {
        var message = JSONRPCMessage.createErrorMessage(error);
        this.sendMessage(message);
    }

    onErrorMessage(error) {
        console.error(error);
    }

    sendMessage(message) {
        console.debug("Sending message", this.port, message);
        if (!this.port) { return; }
        if (!message.isValid) { return; }
        this.port.postMessage(message.stringValue);
    }

    addMessageListener(type, callback) {
        if (!JSONRPCMessage.Type.validate(type)) { return; }
        (this.listeners[type] = this.listeners[type] || []).push(callback);
    }

    removeMessageListener(type, callback) {
        if (!type) { this.listeners = {}; }
        else if (!callback) { delete this.listeners[type]; }
        else { /** TODO */ }
    }

    dispatchMessage(message) {
        var callbacks = this.listeners[message.type.toLowerCase()];
        if (!callbacks) { return; }
        callbacks.forEach(function (callback) {
            callback.call(this, message);
        });
    }

}