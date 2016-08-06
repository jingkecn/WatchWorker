importScripts("EventTarget.js");
/**
 * 
 */
class Window extends EventTarget {

    constructor(instance) {
        super();
        if (this.constructor.name !== "Window") { return; }
        this.instance = instance || scope && scope.createEventTarget();
    }

    // MARK: ********** Window Timers **********
    setImmediate(callback) {
        var args = Array.from(arguments).slice(1);
        console.log("Args in setImmediate", args);
        return WindowTimers.setImmediateWithCallbackWithArgs(callback, args);
    }

    setTimeout(callback, delay) {
        if (typeof callback === "string") {
            console.warn("Should not eval string script");
        }
        delay = (delay === (void 0) || delay < 0) ? 0 : delay;
        var args = Array.from(arguments).slice(2);
        console.log("Args in setTimeout", args);
        return WindowTimers.setTimeoutWithCallbackWithDelayWithArgs(callback, delay, args);
    }

    setInterval(callback, interval) {
        interval = (interval === (void 0) || interval < 0) ? 0 : interval;
        var args = Array.from(arguments).slice(2);
        console.log("Args in setInterval", args);
        return WindowTimers.setIntervalWithCallbackWithIntervalWithArgs(callback, interval, args);
    }

    clearImmediate(id) {
        WindowTimers.clearImmediateById(id);
    }

    clearTimeout(id) {
        WindowTimers.clearTimeoutById(id);
    }

    clearInterval(id) {
        WindowTimers.clearIntervalById(id);
    }

    static create(instance) {
        return new Window(instance);
    }

}

var self = new Window();
var window = self;