importScripts("EventTarget");
importScripts("MessageEvent");
importScripts("Queue");
/**
 * 
 */
class MessagePort extends EventTarget {

    constructor(instance) {
        super();
        if (this.constructor.name !== "MessagePort") { return; }
        this.instance = instance || scope && scope.createMessagePort();
    }

    get onmessage() { return this.__onmessage__; }
    set onmessage(handler) { this.__onmessage__ = handler; this.instance.registerThisJSValue(this); }

    /**
     * Posts a message through the channel. 
     * Objects listed in transfer are transferred, not just cloned, meaning that they are no longer usable on the sending side.
     * Throws a "DataCloneError" DOMException if transfer array contains duplicate objects or the source or target ports, or if message could not be cloned.
     */
    postMessage(message, transfer) {
        // if (!transfer) { transfer = null; }
        this.instance.postMessage(message, transfer);
    }

    /**
     * Begins dispatching messages received on the port.
     */
    start() {
        this.instance.start();
    }

    /**
     * Disconnects the port, so that it is no longer active.
     */
    close() {
        this.instance.close();
    }

    __onmessage__(event) { console.debug("Message received from the entangled port", event.data, event); }

    static create(instance) {
        return new MessagePort(instance);
    }

}