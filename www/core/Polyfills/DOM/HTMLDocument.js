importScripts("Document");
importScripts("HTMLElement");
/**
 * Polyfill
 * HTMLDocument is an abstract interface of the DOM which provides access to special properties and methods not present by default on a regular (XML) document.
 * Its methods and properties are included in the document page and listed separately in their own section in the above linked DOM page.
 */
class HTMLDocument extends Document {

    constructor() {
        super();
        this.body = new HTMLElement();
        this.registerEvent(new Event("load"));
        this.addEventListener("load", this.onload.bind(this));
        this.dispatchEvent(this.getEventByType("load"));
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

    // MARK: ********** Event Handlers **********
    onload(event) { // for testing
        console.debug(`{${this.constructor.name}} loaded`, event);
    }
}