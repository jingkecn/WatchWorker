class WKAbstractController {

    constructor(controlled) {
        this.controlled = controlled
        this.observers = {}
    }

    initialize(parentController) {
        this.parentController = parentController;
    }

    addObserver(observer) {
        if (typeof observer !== "function") { return; }
        this.observers[observer.name] = observer;
    }

    removeObserver(observer) {
        if (typeof observer !== "function") { return; }
        delete this.observers[observer.name];
    }

    dispatchObserver(id, params) {
        var observer = this.observers[id];
        console.log("dispatcing observer", observer);
        if (!observer) { return; }
        if (params && Array.isArray(params)) {
            observer.apply(this, params);
        } else {
            observer.call(this, params);
        }
    } 

}