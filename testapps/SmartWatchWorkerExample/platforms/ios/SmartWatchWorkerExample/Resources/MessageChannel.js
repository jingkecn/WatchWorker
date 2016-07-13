importScripts("JSClassDelegate");
importScripts("MessagePort")

class MessageChannel extends JSClassDelegate {

    constructor(instance) {
        super();
        if (this.constructor.name !== "MessageChannel") { return; }
        this.instance = instance || scope && scope.createMessageChannel();
    }
    
    get port1() {
        var port = this.instance.port1.thisJSValue;
        port && port.start();
        return port;
    }
    get port2() {
        var port = this.instance.port2.thisJSValue;
        port && port.start();
        return port;
    }

    static create(instance) {
        return new MessageChannel(instance);
    }

}