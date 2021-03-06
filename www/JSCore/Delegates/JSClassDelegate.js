/**
 * @interface	{JSClassDelegate}
 */
class JSClassDelegate {

    constructor() {
        if (this.constructor.name === "JSClassDelegate") {
            throw new Error(`Attempt to construct an interface - ${this.constructor.name}`);
        }
        this.__instance__ = null;   // Native instance
    }

    /**
     * Native instance getter
     * Get native instance with an updated JS instance registered.
     * @returns     {NativeInstance}
     */
    get instance() { 
        this.__instance__ && this.__instance__.registerThisJSValue(this);
        return this.__instance__;
    }

    /**
     * Native instance setter
     * Set native instance then update JS instance
     * @patameter   {NativeInstance} instance
     */
    set instance(instance) {
        this.__instance__ = instance;
        this.__instance__.registerThisJSValue(this);
    }

    // static create(instance) {
    //     this.instance = instance;
    //     return this;
    // }

}