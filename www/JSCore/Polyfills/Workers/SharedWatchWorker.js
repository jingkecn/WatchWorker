importScripts("SharedWorker");

class SharedWatchWorker extends SharedWorker {

    constructor(scriptURL, name, instance) {
        super();
        if (this.constructor.name !== "SharedWatchWorker") { return; }
        this.instance = instance || scope && scope.createSharedWatchWorker(scriptURL, name);
    }

    static create(instance) {
        return new SharedWatchWorker(instance.scriptURL, instance.name, instance);
    }

}