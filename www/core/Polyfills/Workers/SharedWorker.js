importScripts("EventTarget");

class SharedWorker extends EventTarget {

    constructor(scriptURL, name, instance) {
        super();
        if (this.constructor.name !== "SharedWorker") { return; }
        this.instance = instance || scope && scope.createSharedWorker(scriptURL, name);
    }

    get port() {
        return this.instance && this.instance.port.thisJSValue || null;
    }

    static create(instance) {
        return new SharedWorker(instance.scriptURL, instance, instance);
    }

}