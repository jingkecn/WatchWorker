importScripts("EventTarget");

class Worker extends EventTarget {

    constructor(scriptURL, instance) {
        super();
        if (this.constructor.name !== "Worker") { return; }
        this.instance = instance || scope && scope.createWorker(scriptURL);
    }

    terminate() {
        this.instance.terminate();
    }

    postMessage(message) {
        this.instance.postMessage(JSON.stringify(message));
    }

    static create(instance) {
        return new Worker(instance.scriptURL, instance);
    }

}