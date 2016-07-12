importScripts("EventTarget");
/**
 * 
 */
class Window extends EventTarget {

    constructor(instance) {
        super();
        // this.__instance__ = 
        this.registerEvent(new Event("load"));
        this.addEventListener("load", this.onload.bind(this));
        this.dispatchEvent("load");
    }

    // MARK: ********** Window Timers **********
    setImmediate(callback) {
        var args = Array.from(arguments).slice(1);
        console.log("Args in setImmediate", args);
        return JSCWindowTimers.setImmediateWithCallbackWithArgs(callback, args);
    }

    setTimeout(callback, delay) {
        if (typeof callback === "string") {
            console.warn("Should not eval string script");
        }
        delay = (delay === (void 0) || delay < 0) ? 0 : delay;
        var args = Array.from(arguments).slice(2);
        console.log("Args in setTimeout", args);
        return JSCWindowTimers.setTimeoutWithCallbackWithDelayWithArgs(callback, delay, args);
    }

    setInterval(callback, interval) {
        interval = (interval === (void 0) || interval < 0) ? 0 : interval;
        var args = Array.from(arguments).slice(2);
        console.log("Args in setInterval", args);
        return JSCWindowTimers.setIntervalWithCallbackWithIntervalWithArgs(callback, interval, args);
    }

    clearImmediate(id) {
        JSCWindowTimers.clearImmediateById(id);
    }

    clearTimeout(id) {
        JSCWindowTimers.clearTimeoutById(id);
    }

    clearInterval(id) {
        JSCWindowTimers.clearIntervalById(id);
    }

    // MARK: ********** Event Handlers **********
    onload(event) { // for testing
        console.debug(`{${this.constructor.name}} loaded`, event);
    }

}