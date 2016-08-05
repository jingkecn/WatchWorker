/**
 * Observable controller
 */
class WKAbstractController {

    constructor(controlled) {
        controlled.initialized = true;
        this.controlled = controlled;
        this.observers = {};
    }

    /**
     * Nested controller implementations.
     * @param   {WKAbstractController}  [required]  parentController
     */
    initialize(parentController) {
        this.parentController = parentController;
    }

    /**
     * Add observer to controller
     * @param   {Function}  [required]  observer
     */
    addObserver(observer) {
        if (typeof observer !== "function") { return; }
        this.observers[observer.name] = observer;
    }

    /**
     * Remove observer to controller
     * @param   {Function}  [required]  observer
     */
    removeObserver(observer) {
        if (typeof observer !== "function") { return; }
        delete this.observers[observer.name];
    }

    /**
     * Dispatch an observer
     * @param   {String}            [required]  id
     * @param   {Array|Dictionary}  [optional] params
     */
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