importScripts("Document");
importScripts("HTMLElement");
/**
 * Polyfill
 * HTMLDocument is an abstract interface of the DOM which provides access to special properties and methods not present by default on a regular (XML) document.
 * Its methods and properties are included in the document page and listed separately in their own section in the above linked DOM page.
 */
class HTMLDocument extends Document {

    constructor(instance) {
        super();
        if (this.constructor.name !== "HTMLDocument") { return; }
        this.instance = instance || scope && scope.createEventTarget();
        this.body = new HTMLElement();
    }
    
    createElement(element) {
        var element = new HTMLElement();
        // this.elements.push(element);
        return element;
    }

    getElementById(id) {
        return new HTMLElement();
    }
    
    getElementsByTagName(name) {
        return [new HTMLElement()];
    }

    static create(instance) {
        return new HTMLDocument(instance);
    }
}

var document = new HTMLDocument();