importScripts("Element.js");
/**
 * Polyfill
 * The HTMLElement interface represents any HTML element. 
 * Some elements directly implement this interface, others implement it via an interface that inherits it.
 */
class HTMLElement extends Element {

    constructor(instance) {
        super();
        if (this.constructor.name !== "HTMLElement") { return; }
        this.instance = instance || scope && scope.createEventTarget();
    }

    static create(instance) {
        return new HTMLElement(instance);
    }
    
    getAttribute(attribute) {
        return "fakeAttribute";
    }
}