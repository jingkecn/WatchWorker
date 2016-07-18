importScripts("JSClassDelegate");
importScripts("WCMessagePort");

class WCMessageChannel extends JSClassDelegate {

    constructor(instance) {
        super();
        if (this.constructor.name !== "WCMessageChannel") { return; }
        this.instance = instance || scope && scope.createWCMessageChannel();
    }

    get port() { return WCMessagePort.create(this.instance.port); }

    static create(instance) {
        return new WCMessageChannel(instance);
    }

}