importScripts("Element");
/**
 * Polyfill
 * The HTMLElement interface represents any HTML element. 
 * Some elements directly implement this interface, others implement it via an interface that inherits it.
 */
class HTMLElement extends Element {

    constructor() {
        super();
    }
    
    getAttribute(attribute) {
        return "fakeAttribute";
    }
}