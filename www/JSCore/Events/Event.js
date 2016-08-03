importScripts("JSClassDelegate");
/**
 * The Event interface represents any event of the DOM. 
 * It contains common properties and methods to any event.
 */
class Event extends JSClassDelegate {
    
    constructor(type, init, instance) {
        super();
        if (this.constructor.name !== "Event") { return; }
        this.instance = instance || scope && scope.createEvent(type, init);   // Native instance
    }

    get type() { return this.instance.type; }
    get target() { return this.instance.target && this.instance.target.thisJSValue || null; }
    get currentTarget() { return this.instance.currentTarget && this.instance.currentTarget.thisJSValue || null; }
    get bubbles() { return this.instance.bubbles/* || false*/; }
    get cancelable() { return this.instance.cancelable/* || false*/; }
    get defaultPrevented() { return this.instance.defaultPrevented/* || false*/; }
    get composed() { return this.instance.composed/* || false*/; }
    get isTrusted() { return this.instance.isTrusted/* || false*/; }
    get timeStamp() { return this.instance.timeStamp; }
    
    stopPropagation() {
        this.instance.stopPropagation();
    }

    stopImmediatePropagation() {
        this.instance.stopImmediatePropagation();
    }

    preventDefault() {
        this.instance.preventDefault();
    }

    initEvent(type, bubbles, cancelable) {
        this.instance.initEvent(type, bubbles, cancelable);
    }

    static create(instance) {
        return new Event(instance.type, {}, instance);
    }
}