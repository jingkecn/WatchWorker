importScripts("Worker");

class WatchWorker extends Worker {

    constructor(scriptURL, instance) {
        super();
        if (this.constructor.name !== "WatchWorker") { return; }
        this.instance = instance || scope && scope.createWatchWorker(scriptURL);
    }

    static create(instance) {
        return new WatchWorker(instance.scriptURL, instance);
    }

}