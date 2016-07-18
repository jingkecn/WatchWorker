importScripts("SharedWorker");

class WCSharedWorker extends SharedWorker {

    constructor(scriptURL, name, options, instance) {
        super(scriptURL, name, options, instance);
        if (this.constructor.name !== "WCSharedWorker") { return; }
        this.instance = instance || scope && scope.createWCSharedWorker(scriptURL, name, options);
    }

    static create(instance) {
        return new WCSharedWorker(instance.initializer.scriptURL, instance.initializer.name, null, instance);
    }

}