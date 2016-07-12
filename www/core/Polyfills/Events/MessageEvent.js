importScripts("Event");

class MessageEvent extends Event {

    constructor(type, init, instance) {
        super(type, init, instance);
        if (this.constructor.name !== "MessageEvent") { return; }
        this.instance = instance || scope && scope.createMessageEvent(type, init);   // Native instance
    }

    // MARK: ********** Getters **********
    get data() { return this.instance.data; }
    get origin() { return this.instance.origin; }
    get lastEventId() { return this.instance.lastEventId; }
    get source() { return this.instance && this.instance.source && this.instance.source.thisJSValue || null; }
    get ports() {
        return this.instance.ports.map(function(nativePort) {
            return nativePort.thisJSValue || null;
        });
    }

    // MARK: ********** Initialization **********
    initMessageEvent(type, bubbles, cancelable, data, origin, lastEventId, source, ports) {
        this.instance.initMessageEvent(
            type, 
            bubbles, 
            cancelable, 
            data, 
            origin, 
            lastEventId, 
            source.instance, 
            ports.map(function (port) { return port.instance || null; })
        );
    }

    static create(instance) {
        return new MessageEvent(instance.type, {}, instance);
    }

}