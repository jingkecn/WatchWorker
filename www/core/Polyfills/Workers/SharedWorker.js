importScripts("EventTarget");

class SharedWorker extends EventTarget {

    constructor(scriptURL, name, options, instance) {
        super();
        if (this.constructor.name !== "SharedWorker") { return; }
        this.instance = instance || scope && scope.createSharedWorker(scriptURL, name, options);
    }

    get port() {
        return this.instance && this.instance.port.thisJSValue || null;
    }

}