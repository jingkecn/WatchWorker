importScripts("JSClassDelegate");
/**
 * @interface	{EventTarget}
 */
class EventTarget extends JSClassDelegate {

    constructor(instance) {
        super();
        if (this.constructor.name === "EventTarget") {
            throw new Error(`Illegal constructor - ${this.constructor.name}`);
        }
    }

    get onload() { return this.__onload__; }
    set onload(handler) { this.__onload__ = handler; this.instance.registerThisJSValue(this); }

    /**
     * @parameter	{String} type
     * @parameter	{EventListener} callback
     * @parameter	{AddEventListenerOptions|Boolean} options
     */
    addEventListener(type, callback, options) {
        this.instance && this.instance.addEventListener(type, callback, options);
        return this;
    }

    /**
     * @parameter	{String} type
     * @parameter	{EventListener} callback
     * @parameter	{AddEventListenerOptions|Boolean} options
     */
    removeEventListener(type, callback, options) {
        this.instance && this.instance.removeEventListener(type, callback, options);
        return this;
    }

    /**
     * @parameter	{Event} event
     * @returns     {Boolean}  
     */
    dispatchEvent(event) {
        if (!this.instance) { return false; }
        if (typeof event === "string") { 
            event = this.instance.getEventByType(event); 
            if (event) {
                return this.instance.dispatchEvent(event);
            }
        }
        if (!event) { return false; }
        return this.instance.dispatchEvent(event.instance);
    }

    // registerEvent(event) {
    //     this.instance && this.instance.registerEvent(event.instance);
    // }

    // getEventByType(type) {
    //     return this.instance &&  this.instance.getEventByType(type).thisJSValue;
    // }

    __onload__(event) { console.info(`[${this.constructor.name}] loaded`, event); }

}