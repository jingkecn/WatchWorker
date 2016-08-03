importScripts("MessagePort");

class WCMessagePort extends MessagePort {

    constructor(instance) {
        super();
        if (this.constructor.name !== "WCMessagePort") { return; }
        this.instance = instance || scope && scope.createWCMessagePort();
    }

    postMessage(message, transfer) {
        if (typeof message === "object") {
            message = JSON.stringify(message);
        }
        super.postMessage(message);
    }

    onwatchconnected(event) { console.info("On smart watch connected", event); }
    onwatchdisconnected(event) { console.info("On smart watch disconnected", event); }

    static create(instance) {
        return new WCMessagePort(instance);
    }

}